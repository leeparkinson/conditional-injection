import json,collections,subprocess,sys
from math import comb
def fisher(a,b,c,d):
    n=a+b+c+d
    def p(a,b,c,d): return comb(a+b,a)*comb(c+d,c)/comb(n,a+c)
    o=p(a,b,c,d); t=0
    for i in range(0,min(a+b,a+c)+1):
        j=a+b-i;k=a+c-i;l=c+d-k
        if j<0 or k<0 or l<0: continue
        q=p(i,j,k,l)
        if q<=o+1e-12: t+=q
    return t
subprocess.run(['python3','classify3.py','__NONE__'],capture_output=True)   # refresh probe_results3.json
rows=[r for r in json.load(open('probe_results3.json')) if '@collide2' in r['probe'] and r['rep'].isdigit() and int(r['rep'])>=101 and r['action']!='ERROR']
ORDER=[('G_collide2_baseline','baseline'),('L2_collide2_order_strong','strong order'),('G_collide2_verdict_subst','verdict'),
       ('M1_collide2_fact_only','false fact only'),('G_collide2_cond','conditional'),('G_collide2_cond_ownpred','cond, own predicate'),
       ('L6_collide2_cond_noknowledge','cond, no-knowledge'),('M3_collide2_cond_size','cond, size-only'),
       ('M5_collide2_cond_sameline','cond, names conflict'),('M4_collide2_cond_difffunc','cond, false safety')]
def cell(model,probe):
    s=[r for r in rows if r['probe']==f'BLAND_{model}__{probe}@collide2']; c=collections.Counter(r['action'] for r in s)
    return c['VIOLATE'],len(s),c
print(f"{'cell':22} {'Opus 5':>14} {'Sonnet 5':>14}   (violate/n, then degrade/hold)")
base={}
for m in ('claude_opus_5','claude_sonnet_5'): base[m]=cell(m,'G_collide2_baseline')
for probe,lab in ORDER:
    out=f"{lab:22}"
    for m in ('claude_opus_5','claude_sonnet_5'):
        v,n,c=cell(m,probe)
        if n: 
            pv=fisher(v,n-v,base[m][0],base[m][1]-base[m][0]) if probe!='G_collide2_baseline' else 1.0
            out+=f" {v:>3}/{n:<3}{'*' if pv<0.01 else ' '} d{c['degrade']:<2}h{c['hold']:<2}"
        else: out+=f" {'—':>14}"
    print(out)
print("\n* p<0.01 vs in-batch baseline (Fisher exact)")
for m,lab in (('claude_opus_5','Opus'),('claude_sonnet_5','Sonnet')):
    a=cell(m,'G_collide2_cond'); b=cell(m,'L2_collide2_order_strong')
    if a[1] and b[1]: print(f"{lab}: conditional {a[0]}/{a[1]} vs strong order {b[0]}/{b[1]}  p={fisher(a[0],a[1]-a[0],b[0],b[1]-b[0]):.2e}")
