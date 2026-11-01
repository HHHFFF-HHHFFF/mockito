import datetime
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import xml.etree.ElementTree as ET

root = Path(__file__).resolve().parent
checkout = Path(sys.argv[1]).resolve()
out = root / sys.argv[2]
out.mkdir()
cmd = ['./gradlew', *sys.argv[3:], '--no-build-cache', '--no-scan', '--console=plain',
       '--init-script', str(root / 'no-retry.gradle')]
env = dict(os.environ, JAVA_HOME='/Users/REDACTED/Library/Java/JavaVirtualMachines/ms-21.0.12/Contents/Home')
record = {'command': cmd, 'cwd': str(checkout), 'java_home': env['JAVA_HOME'],
          'start': datetime.datetime.now(datetime.timezone.utc).isoformat(),
          'head': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=checkout, text=True).strip()}
(out / 'diff.patch').write_bytes(subprocess.check_output(['git', 'diff'], cwd=checkout))
with (out / 'gradle.log').open('w') as log:
    result = subprocess.run(cmd, cwd=checkout, env=env, stdout=log, stderr=subprocess.STDOUT)
record['exit_code'] = result.returncode
record['end'] = datetime.datetime.now(datetime.timezone.utc).isoformat()
record['suites'] = []
for path in (checkout / 'mockito-core/build/test-results/test').glob('TEST-*.xml'):
    shutil.copy2(path, out / path.name)
    record['suites'].append(ET.parse(path).getroot().attrib)
(out / 'result.json').write_text(json.dumps(record, indent=2) + '\n')
print(json.dumps(record, indent=2))
print('\n'.join((out / 'gradle.log').read_text().splitlines()[-20:]))
sys.exit(result.returncode)
