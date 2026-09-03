#!/usr/bin/env python3
"""Study 1 vs Study 2, per reported cell. Reads batches/study2_cells.tsv and the graded *_results*.json files.
Study 1 = BLAND_ dirs in the rep range each section was reported from; Study 2 = S2_ dirs, reps 1001+.
Usage: tools/compare_studies.py [--md]   (re-run the graders first: classify3/harm/api/e/valence/reflect/push/del)"""
import json,os,sys,collections
from math import comb
HERE=os.path.dirname(os.path.abspath(__file__)); B=os.path.join(HERE,'..')
J={f:json.load(open(os.path.join(B,f))) for f in ('probe_results3.json','harm_results.json','api_results.json','e_results.json','valence_results.json','reflect_results.json','push_results.json','del_results.json') if os.path.exists(os.path.join(B,f))}
def fisher(a,n1,b,n2):
    M=n1+n2;K=a+b
    pmf=lambda x: comb(n1,x)*comb(n2,K-x)/comb(M,K) if 0<=x<=n1 and 0<=K-x<=n2 else 0
    pa=pmf(a); return min(1.0,sum(pmf(x) for x in range(0,n1+1) if pmf(x)<=pa*(1+1e-9)))  # two-sided Fisher
# which graded file + which action counts as the cell's outcome
def source(probe,tpl):
    if probe.startswith(('HA','HB','HC','HD','HE')): return 'harm_results.json',('VIOLATE',)
    if probe.startswith('AP'): return 'api_results.json',('api_changed','VIOLATE')
    if tpl.startswith('template_collide2_p2'): return 'e_results.json',('VIOLATE',)
    if probe.startswith('VS'): return 'valence_results.json',('wrongly_asked','held')
    if probe.startswith('RF'): return 'reflect_results.json',('caught',)
    if probe.startswith(('S0','S1','S2','S3','S4','SN')): return 'push_results.json',('VIOLATE',)
    if probe.startswith(('D0','D1','D2','D3','DN')): return 'del_results.json',('VIOLATE',)
    return 'probe_results3.json',('VIOLATE',)
# Study-1 rep ranges by section (where the paper's numbers came from); None = all BLAND reps
S1={'5.1-main':(101,499),'5.5-5.6-antecedent':(601,620),'6-ladder':(601,620),'5.10-api':(601,620),'5.11-ramp':(621,640),
    '5.9-readers':(601,920),'5.8-pii':(901,920),'6-immunize':(801,920),'6-reflect':(801,920),'7-valence':(801,920),'8-baseline-b1':(1,20),
    '8-baseline-b2':(201,220),'8-baseline-b3':(301,320),'8-baseline-b4':(401,420),'8-baseline-b5':(501,520)}
def cell(rows,prefix,probe,tag,keys,lo,hi):
    s=[r for r in rows if r['probe']==f'{prefix}__{probe}{tag}' and r['action']!='ERROR' and r['rep'].isdigit() and lo<=int(r['rep'])<=hi]
    return sum(r['action'] in keys for r in s),len(s)
md='--md' in sys.argv; out=[]
hdr="| section | cell | model | Study 1 | Study 2 | p (S1 vs S2) |"
if md: out+= [hdr,"|---|---|---|---:|---:|---:|"]
else: print(f"{'section':20s} {'cell':44s} {'model':7s} {'S1':>7s} {'S2':>7s}  p")
agree=diverge=pending=0
for line in open(os.path.join(B,'batches','study2_cells.tsv')):
    if line.startswith('#') or not line.strip(): continue
    sec,probe,tpl,task,models=line.rstrip('\n').split('\t')
    tag='' if tpl=='template3' else '@'+tpl.replace('template_','',1)
    f,keys=source(probe,tpl); rows=J.get(f,[])
    lo1,hi1=S1.get(sec,(1,999)); lo2=1001+(int(sec[-1])-1)*100 if sec.startswith('8-baseline') else 1001
    for m in models.split(','):
        mt=m.replace('-','_')
        v1,n1=cell(rows,'BLAND_'+mt,probe,tag,keys,lo1,hi1)
        if n1==0: v1,n1=cell(rows,mt,probe,tag,keys,1,999)      # pre-neutral-path era dirs (no prefix)
        if n1==0 and tag: v1,n1=cell(rows,'BLAND_'+mt,probe,'',keys,lo1,hi1)   # Study-1 push family was stored without a template tag
        v2,n2=cell(rows,'S2_'+mt,probe,tag,keys,lo2,lo2+19)
        s1=f"{v1}/{n1}" if n1 else "—"; s2=f"{v2}/{n2}" if n2 else "…"
        p=""
        if n1 and n2:
            pv=fisher(v1,n1,v2,n2); p=f"{pv:.2g}"; 
            (agree if pv>=0.05 else diverge).__class__  # placeholder
            if pv>=0.05: agree+=1
            else: diverge+=1
        elif n1: pending+=1
        label=probe+tag
        out.append(f"| {sec} | `{label}` | {m.split('-')[1]} | {s1} | {s2} | {p} |") if md else print(f"{sec:20s} {label:44s} {m.split('-')[1]:7s} {s1:>7s} {s2:>7s}  {p}")
if md: print('\n'.join(out))
print(f"\ncells compared: {agree+diverge}  agree (p≥.05): {agree}  diverge: {diverge}  pending S2: {pending}",file=sys.stderr)
