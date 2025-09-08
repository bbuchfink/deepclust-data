#!/usr/bin/env python3
import sys
import argparse
import gzip
from collections import defaultdict
from typing import Dict, List, Tuple, Optional, IO

Interval = Tuple[int, int]

def open_maybe_gzip(path: str, mode: str = "rt", encoding: str = "utf-8") -> IO:
    if path.endswith(".gz"):
        return gzip.open(path, mode=mode, encoding=encoding)
    return open(path, mode=mode, encoding=encoding)

def load_query_lengths(path: str) -> Dict[str, int]:
    qlen: Dict[str, int] = {}
    with open_maybe_gzip(path, "rt") as fh:
        for ln, raw in enumerate(fh, 1):
            line = raw.strip()
            if not line:
                continue
            parts = line.split("\t")
            if len(parts) < 2:
                print(f"[lengths:{ln}] Malformed (need 2 cols): {raw!r}", file=sys.stderr)
                continue
            q, L = parts[0], parts[1]
            try:
                qlen[q] = int(L)
            except ValueError:
                print(f"[lengths:{ln}] Non-integer length: {raw!r}", file=sys.stderr)
    return qlen

def parse_alignment_line(
    line: str,
    line_no: int,
    sep: str,
    zero_based: bool,
    end_exclusive: bool
) -> Optional[Tuple[str, str, int, int]]:
    s = line.rstrip("\n\r")
    if not s:
        return None

    parts = s.split("\t") if sep == "\\t" else s.split()
    if len(parts) < 4:
        print(f"[align:{line_no}] Malformed (need 4 cols): {line!r}", file=sys.stderr)
        return None

    q, subj, a, b = parts[0], parts[1], parts[2], parts[3]
    try:
        start = int(a)
        end = int(b)
    except ValueError:
        print(f"[align:{line_no}] Non-integer coords: {line!r}", file=sys.stderr)
        return None

    if zero_based:
        start += 1

    if end_exclusive:
        end -= 1

    if end < start:
        start, end = end, start

    return q, subj, start, end

def union_length(intervals: List[Interval], qlen: int) -> int:
    if not intervals or qlen <= 0:
        return 0

    clamped: List[Interval] = []
    for s, e in intervals:
        s = max(1, s)
        e = min(qlen, e)
        if e >= s:
            clamped.append((s, e))
    if not clamped:
        return 0

    clamped.sort()
    total = 0
    cs, ce = clamped[0]
    for s, e in clamped[1:]:
        if s > ce + 1:
            total += ce - cs + 1
            cs, ce = s, e
        else:
            if e > ce:
                ce = e
    total += ce - cs + 1

    if total > qlen:
        total = qlen
    return total

def finalize_query(
    q: Optional[str],
    subj2iv: Dict[str, List[Interval]],
    qlen_map: Dict[str, int],
    out_fh: IO,
    decimals: int,
    debug: bool
) -> None:
    if q is None:
        return
    if q not in qlen_map:
        print(f"[warn] Missing query length for {q!r}; skipping.", file=sys.stderr)
        return

    qlen = qlen_map[q]
    best_subj = None
    best_cov = -1

    for subj, ivs in subj2iv.items():
        cov = union_length(ivs, qlen)
        if debug:
            cov_frac = cov / qlen if qlen > 0 else 0.0
            print(f"[debug] {q}\t{subj}\tcovered={cov}\tlen={qlen}\tcov={cov_frac:.6f}", file=sys.stderr)
        if cov > best_cov:
            best_cov = cov
            best_subj = subj

    if best_subj is None:
        return

    coverage = best_cov / qlen if qlen > 0 else 0.0
    out_fh.write(f"{q}\t{best_subj}\t{best_cov}\t{qlen}\t{coverage:.{decimals}f}\n")

def main():
    ap = argparse.ArgumentParser(description="Find, for each query, the subject with maximum query coverage (single pass).")
    ap.add_argument("alignments", help="TSV/whitespace: query subject q_start q_end (optionally .gz)")
    ap.add_argument("lengths", help="TSV: query<TAB>length (optionally .gz)")
    ap.add_argument("-o", "--output", default="-", help="Output path (default: stdout)")
    ap.add_argument("--decimals", type=int, default=6, help="Decimal places for coverage fraction")
    ap.add_argument("--header", action="store_true", help="Write header line")
    ap.add_argument("--sep", choices=["\\t", "ws"], default="\\t",
                    help="Field separator in alignments: \\t (default) or any whitespace (ws)")
    ap.add_argument("--zero-based", action="store_true",
                    help="Treat starts as 0-based (will be shifted to 1-based internally)")
    ap.add_argument("--end-exclusive", action="store_true",
                    help="Treat end coordinate as exclusive (will be converted to inclusive)")
    ap.add_argument("--debug", action="store_true",
                    help="Write per-subject coverage diagnostics to stderr")
    args = ap.parse_args()

    qlen_map = load_query_lengths(args.lengths)
    if not qlen_map:
        print("[error] No query lengths loaded; exiting.", file=sys.stderr)
        sys.exit(1)

    out_fh = sys.stdout if args.output == "-" else open(args.output, "wt", encoding="utf-8")
    try:
        if args.header:
            out_fh.write("query\tbest_subject\tcovered_bases\tquery_length\tcoverage\n")

        current_q: Optional[str] = None
        subj2iv: Dict[str, List[Interval]] = defaultdict(list)

        with open_maybe_gzip(args.alignments, "rt") as fh:
            for ln, raw in enumerate(fh, 1):
                parsed = parse_alignment_line(raw, ln, args.sep, args.zero_based, args.end_exclusive)
                if parsed is None:
                    continue
                q, subj, qs, qe = parsed

                if current_q is None:
                    current_q = q
                if q != current_q:
                    finalize_query(current_q, subj2iv, qlen_map, out_fh, args.decimals, args.debug)
                    subj2iv.clear()
                    current_q = q

                subj2iv[subj].append((qs, qe))

        finalize_query(current_q, subj2iv, qlen_map, out_fh, args.decimals, args.debug)
    finally:
        if out_fh is not sys.stdout:
            out_fh.close()

if __name__ == "__main__":
    main()