#include <iostream>
#include <fstream>
#include <unordered_map>
#include <string>
#include <string.h>
#include <map>

using namespace std;

unordered_map<string, string> acc2arch;
unordered_map<string, string> fam2clan;
unordered_map<string, int> clust, clust_clan, counts;
multimap<string, string> arch2query, clan_arch2query;
double sens_a = 0, prec_a = 0, prec_w = 0, sum_w = 0;

bool query_level = false;

string path(const string& file) {
	size_t pos = file.find_last_of("/\\");

	if (pos != std::string::npos)
		return file.substr(0, pos);
	else
		return ".";
}

string clan_arch(const string& arch) {
	size_t i = 0;
	string r;
	for(;;) {
		size_t j = arch.find('_', i);
		if(j == string::npos) {
			const string fam = arch.substr(i);
			if(!r.empty())
				r += '_';
			const auto it = fam2clan.find(fam);
			r += it == fam2clan.end() ? fam : it->second;
			return r;
		}
		const string fam = arch.substr(i, j - i);
		if(!r.empty())
			r += '_';
		const auto it = fam2clan.find(fam);
		r += it == fam2clan.end() ? fam : it->second;
		i = j + 1;
		if(i >= arch.length())
			break;
	}
	return r;
}

void aln_file(const char* name) {
	string query, target, query_arch, curr, query_arch_clan;
	ifstream in(name);
	int tp=0, fp=0,n=0;
	while(in >> query >> target) {
		if(query != curr) {
			++n;
			cerr << n << endl;
			if(tp+fp > 0) cout << curr << '\t' << (double)tp / counts[query_arch] << '\t' << (double)tp / (tp+fp) << endl;
			query_arch = acc2arch.at(query);
			query_arch_clan = clan_arch(query_arch);
			curr = query;
			tp = 0;
			fp = 0;
		}
		auto it = acc2arch.find(target);
		if(it != acc2arch.end()) {
			const auto& target_arch = it->second;
			if(target_arch == query_arch)
				++tp;
			else if(clan_arch(target_arch) != query_arch_clan)
				++fp;
		}
	}
}

void eval_cluster(const string& rep) {
	int size=0;
	for(const auto& arch : clust)
		size += arch.second;
	for(const auto& arch: clust) {
		const double arch_size = counts[arch.first];
		const double sens = (double)arch.second / arch_size;
		//prec = (double)arch.second / size;
		if(query_level) {
			auto its = arch2query.equal_range(arch.first);
			for(auto it = its.first; it != its.second; ++it)
				cout << "SENS" << '\t' << it->second << '\t' << sens << endl;
		} else
			cout << "SENS" << '\t' << arch.first << '\t' << arch.second << '\t' << sens << '\t' << rep << endl;
		sens_a += arch.second * sens;
		//prec_a += arch.second * prec;
	}
	for(const auto& arch : clust_clan) {
		const double arch_size = counts[arch.first];
		const double prec = (double)arch.second / size;
		if(query_level) {
			auto its = clan_arch2query.equal_range(arch.first);
			for (auto it = its.first; it != its.second; ++it)
				cout << "PREC" << '\t' << it->second << '\t' << prec << endl;
		} else
			cout << "PREC" << '\t' << arch.first << '\t' << arch.second << '\t' << prec << '\t' << rep << endl;
		prec_a += arch.second * prec;
		prec_w += arch.second * prec / size;
		sum_w += 1.0 / size * arch.second;
	}
}

int main(int argc, char** argv) {
	if (argc <= 1 || (argv[1] != string("clust") && argv[1] != string("aln"))) {
		cerr << "Command missing/invalid, options: clust, aln" << endl;
		return 1;
	}
	const string data_file = argv[2];
	ifstream map_file(data_file);
	string acc, arch;
	acc2arch.reserve(149824975);
	int n=0;
	while(map_file >> acc >> arch) {
		acc2arch[acc] = arch;
		++counts[arch];
		++n;
		if(n % 1000000 == 0)
			cerr << n << endl;
	}
	cerr << "Accessions = " << acc2arch.size() << endl;
	cerr << "Archs = " << counts.size() << endl;

	ifstream clan_file(path(data_file) + "/clan2acc.tsv");
	string clan, fam;
	while(clan_file >> clan >> fam) {
		fam2clan[fam] = clan;
	}
	
	cerr << "Families mapped to clan = " << fam2clan.size() << endl;

	if (strcmp(argv[1], "aln") == 0) {
		aln_file(argv[3]);
		return 0;
	}

	ifstream in_file(argv[3]);
	string rep, member, curr;
	n=0;
	int ignored=0,total=0;
	while(in_file >> rep >> member) {
		if(rep != curr) {
			eval_cluster(curr);
			curr = rep;
			clust.clear();
			clust_clan.clear();
			arch2query.clear();
			clan_arch2query.clear();
		}
		const auto it = acc2arch.find(member);
		if(it == acc2arch.end()) {
			++ignored;
		} else {
			const string& arch = it->second;
			const string ca = clan_arch(arch);
			++clust[arch];
			++clust_clan[ca];
			++n;
			if (query_level) {
				arch2query.emplace(arch, member);
				clan_arch2query.emplace(ca, member);
			}
		}
		++total;
		if(total % 100000 == 0)
			cerr << total << endl;
	}
	eval_cluster(curr);
	cerr << "Total = " << total << endl;
	cerr << "Annotated = " << n << endl;
	cerr << "Sens = " << sens_a / n << endl;
	cerr << "Prec = " << prec_a / n << endl;
	cerr << "Prec_w = " << prec_w / sum_w << endl;

	return 0;
}
