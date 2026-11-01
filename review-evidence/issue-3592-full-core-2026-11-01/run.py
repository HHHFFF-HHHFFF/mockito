from pathlib import Path
import os,subprocess,json,datetime,shutil,xml.etree.ElementTree as ET
out=Path(__file__).resolve().parent
repo=out.parent.parent/'mockito-3592'
env=os.environ.copy();env['JAVA_HOME']='/Users/REDACTED/Library/Java/JavaVirtualMachines/ms-21.0.12/Contents/Home';env['PATH']=env['JAVA_HOME']+'/bin:'+env['PATH']
cmd=['./gradlew',':mockito-core:test',':mockito-core:check',':mockito-core:spotlessCheck','--max-workers=1','--no-build-cache','--no-scan','--console=plain','--init-script',str(out.parent/'no-retry.gradle')]
record={'start':datetime.datetime.now(datetime.timezone.utc).isoformat(),'command':cmd,'cwd':str(repo),'java_home':env['JAVA_HOME'],'head':subprocess.check_output(['git','rev-parse','HEAD'],cwd=repo,text=True).strip(),'java_version':subprocess.check_output(['java','-version'],env=env,stderr=subprocess.STDOUT,text=True)}
(out/'result.json').write_text(json.dumps(record,indent=2))
with (out/'gradle.log').open('w') as log:
 p=subprocess.Popen(cmd,cwd=repo,env=env,stdout=log,stderr=subprocess.STDOUT);code=p.wait()
record.update(exit_code=code,end=datetime.datetime.now(datetime.timezone.utc).isoformat())
source=repo/'mockito-core/build/test-results/test';dest=out/'xml';dest.mkdir(exist_ok=True)
suites=[]
for f in source.glob('TEST-*.xml'):
 shutil.copy2(f,dest/f.name);r=ET.parse(f).getroot();suites.append({k:r.get(k) for k in ('name','tests','failures','errors','skipped','timestamp')})
record['suites']=suites;record['totals']={k:sum(int(s[k] or 0) for s in suites) for k in ('tests','failures','errors','skipped')}
(out/'result.json').write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps({k:v for k,v in record.items() if k!='suites'},indent=2));raise SystemExit(code)
