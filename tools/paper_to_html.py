#!/usr/bin/env python3
"""Render PAPER.md to the artifact HTML (body regenerated; page identity/CSS fixed). Usage: tools/paper_to_html.py OUT.html"""
import re,html,sys,os
HERE=os.path.dirname(os.path.abspath(__file__)); md=open(os.path.join(HERE,'..','PAPER.md')).read(); OUT=sys.argv[1]
def smart(t):
    t=re.sub(r'(^|[\s(\[—–>-])"',r'\1&ldquo;',t); t=t.replace('"','&rdquo;')
    t=re.sub(r"(^|[\s(\[—–>-])'",r"\1&lsquo;",t); t=t.replace("'","&rsquo;")
    return re.sub(r'(</[a-z]+>)&ldquo;',r'\1&rdquo;',t)
def inline(t):
    codes=[]
    def stash(m): codes.append('<code>'+html.escape(m.group(1),quote=False)+'</code>'); return f'\x00{len(codes)-1}\x00'
    t=re.sub(r'`([^`]*)`',stash,t); e=html.escape(t,quote=False)
    e=re.sub(r'\*\*(.+?)\*\*',r'<strong>\1</strong>',e)
    e=re.sub(r'(?<![\w*])\*(?!\s)(.+?)(?<!\s)\*(?![\w*])',r'<em>\1</em>',e)
    e=smart(e); return re.sub(r'\x00(\d+)\x00',lambda m:codes[int(m.group(1))],e)
lines=md.split('\n'); i=0; body=[]; title=sub=None; ab=False
def close():
    global ab
    if ab: body.append('</div>'); ab=False
while i<len(lines):
    ln=lines[i]
    if ln.startswith('# '): sub,title=ln[2:].split(': ',1); i+=1; continue
    if ln.startswith('*Draft'): body.append('<p class="note">'+inline(ln.strip('*'))+'</p>'); i+=1; continue
    if ln.startswith('## '):
        close(); h=ln[3:]; body.append('<h2>'+inline(h)+'</h2>')
        if h=='Abstract': body.append('<div class="abstract">'); ab=True
        i+=1; continue
    if ln.startswith('### '): close(); body.append('<h3>'+inline(ln[4:])+'</h3>'); i+=1; continue
    if ln.startswith('|'):
        rows=[]
        while i<len(lines) and lines[i].startswith('|'): rows.append([c.strip() for c in lines[i].strip().strip('|').split('|')]); i+=1
        hdr,align,data=rows[0],rows[1],rows[2:]; num=[a.endswith(':') for a in align]
        if hdr[0]=='message' and any('if it is' in r[0] for r in data):
            def cell(r):
                s=re.sub(r'\*\*(.+?)\*\*',r'<mark>\1</mark>',r[0].strip('"')); s=re.sub(r'`([^`]*)`',r'<code>\1</code>',s).replace("'","&rsquo;")
                n=r[1].replace('*',''); cls='no' if n.startswith('0/') else 'ok'; a,b=n.split('/')
                return f'<div class="spec"><p class="stim">{s}</p><p class="count {cls}">{a}<span>/{b}</span></p><p class="lab">edits the forbidden file</p></div>'
            body.append('<figure class="specimen" aria-label="The two-word contrast">'+''.join(cell(r) for r in data)+'<figcaption>Same speaker, same channel, same predicate, same working tree. Opus&nbsp;5, genuine same-line conflict, <i>p</i>&nbsp;=&nbsp;3×10⁻¹⁰.</figcaption></figure>'); continue
        th=''.join(f'<th{" class=\"num\"" if num[k] else ""}>{inline(c)}</th>' for k,c in enumerate(hdr)); trs=''
        for r in data:
            r=(r+['']*len(hdr))[:len(hdr)]; trs+='<tr>'+''.join(f'<td{" class=\"num\"" if num[k] else ""}>{inline(c)}</td>' for k,c in enumerate(r))+'</tr>'
        body.append(f'<div class="tbl"><table><thead><tr>{th}</tr></thead><tbody>{trs}</tbody></table></div>'); continue
    if re.match(r'^\d+\. ',ln) or ln.startswith('- '):
        ordered=bool(re.match(r'^\d+\. ',ln)); items=[]
        while i<len(lines) and (re.match(r'^\d+\. ',lines[i]) or lines[i].startswith('- ')): items.append(re.sub(r'^(\d+\. |- )','',lines[i])); i+=1
        tag='ol' if ordered else 'ul'; body.append(f'<{tag}>'+''.join('<li>'+inline(x)+'</li>' for x in items)+f'</{tag}>'); continue
    if ln.strip()=='': i+=1; continue
    para=[ln]; i+=1
    while i<len(lines) and lines[i].strip() and not re.match(r'^(#|\||\d+\. |- |\*Draft)',lines[i]): para.append(lines[i]); i+=1
    text=' '.join(para)
    body.append(('<p class="cap">'+inline(text[1:-1])+'</p>') if (text.startswith('*(') and text.endswith(')*')) else ('<p>'+inline(text)+'</p>'))
close()
head=open(os.path.join(HERE,'paper_head.html')).read()
date=re.search(r'\*Draft — (\d{4}-\d{2}-\d{2})',md).group(1)
mast=f'<div class="page">\n<header class="mast"><p class="eyebrow">Draft &middot; {date}</p><h1>{inline(title)}</h1><p class="eyebrow" style="margin:1.25rem 0 0">{inline(sub)[0]+inline(sub)[1:].lower()}</p></header>\n'
open(OUT,'w').write(head+mast+'\n'.join(body)+'\n</div>\n'); print("wrote",OUT)
