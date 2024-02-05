#!/usr/bin/env python

from transformers import T5Tokenizer, T5Model
from Bio import SeqIO
import re
import torch
import sys

def add_spaces(seq):
    s = ""
    for i in range(0, len(seq)):
        s += seq[i]
        s += ' '
    return s

def mean_pooling(model_output, attention_mask):
    token_embeddings = model_output
    us = attention_mask.unsqueeze(-1)
    size = token_embeddings.size()
    input_mask_expanded = us.expand(size)
    input_mask_expanded = input_mask_expanded.float()
    return torch.sum(token_embeddings * input_mask_expanded, 1) / torch.clamp(input_mask_expanded.sum(1), min=1e-9)

print(torch.cuda.is_available())
device = "cuda:0" if torch.cuda.is_available() else "cpu"
tokenizer = T5Tokenizer.from_pretrained('Rostlab/prot_t5_xl_uniref50', do_lower_case=False)

model = T5Model.from_pretrained("Rostlab/prot_t5_xl_uniref50")
model = model.to(device)
out = open(sys.argv[2], "wt")

def embed(id, seq):

    seqs = [ add_spaces(seq) ]

    sequences_Example = [re.sub(r"[UZOB]", "X", sequence) for sequence in seqs]

    ids = tokenizer.batch_encode_plus(sequences_Example, add_special_tokens=True, padding=True)

    input_ids = torch.tensor(ids['input_ids']).to(device)
    attention_mask = torch.tensor(ids['attention_mask'])
    am2 = attention_mask.to(device)

    with torch.no_grad():
        embedding = model(input_ids=input_ids,attention_mask=am2,decoder_input_ids=input_ids)

    encoder_embedding = embedding[2].cpu() #.numpy()
    #decoder_embedding = embedding[0].cpu() #.numpy()
    #encoded_input = tokenizer(seqs, padding=True, truncation=True, return_tensors='pt')
    pooling = mean_pooling(encoder_embedding, attention_mask)
    out.write(id)
    for i in range(0, len(pooling[0])):
        out.write('\t')
        out.write("{:10.5f}".format(pooling[0][i].item()))
    out.write('\n')


with open(sys.argv[1]) as handle:
    for record in SeqIO.parse(handle, "fasta"):
        if len(record.seq) <= 1024:
            embed(record.id, record.seq)

