from pathlib import Path
import argparse,plistlib,subprocess,tempfile,time
parser=argparse.ArgumentParser()
parser.add_argument('--device',required=True,help='iOS simulator UDID')
parser.add_argument('--output',default=None)
parser.add_argument('--display',default='1',help='simctl display ID, defaults to primary display')
args=parser.parse_args();repo=Path(__file__).resolve().parents[1];source=repo/'IQKeyboardManagerObjC'
out=Path(args.output or tempfile.mkdtemp(prefix='iq-toolbar-check-'));out.mkdir(parents=True,exist_ok=True)
app=out/'IQToolbarCheck.app';app.mkdir(exist_ok=True);bundle='local.iq.toolbarcheck'
info={'CFBundleExecutable':'IQToolbarCheck','CFBundleIdentifier':bundle,'CFBundleName':'IQToolbarCheck','CFBundlePackageType':'APPL','CFBundleShortVersionString':'1.0','CFBundleVersion':'1','MinimumOSVersion':'15.0','UIDeviceFamily':[1,2],'UILaunchScreen':{},'UIApplicationSceneManifest':{'UIApplicationSupportsMultipleScenes':False,'UISceneConfigurations':{'UIWindowSceneSessionRoleApplication':[{'UISceneConfigurationName':'Default','UISceneDelegateClassName':'IQToolbarCheck'}]}}}
(app/'Info.plist').write_bytes(plistlib.dumps(info))
sdk=subprocess.check_output(['xcrun','--sdk','iphonesimulator','--show-sdk-path'],text=True).strip()
cmd=['xcrun','--sdk','iphonesimulator','clang','-arch','arm64','-isysroot',sdk,'-mios-simulator-version-min=15.0','-fobjc-arc','-fmodules','-fmodules-cache-path='+str(out/'modulecache')]
for folder in [source,*[p for p in source.rglob('*') if p.is_dir()]]:cmd+=['-I',str(folder)]
cmd += [str(repo/'Tests/IQToolbarCheck.m'),*[str(p) for p in sorted(source.rglob('*.m'))]]
for framework in ['UIKit','Foundation','CoreGraphics','QuartzCore']:cmd+=['-framework',framework]
cmd+=['-o',str(app/'IQToolbarCheck')]
with (out/'compile.log').open('w') as log:subprocess.run(cmd,stdout=log,stderr=subprocess.STDOUT,check=True)
subprocess.run(['codesign','--force','--sign','-',str(app)],check=True)
subprocess.run(['xcrun','simctl','bootstatus',args.device,'-b'],check=True)
subprocess.run(['xcrun','simctl','terminate',args.device,bundle],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
subprocess.run(['xcrun','simctl','install',args.device,str(app)],check=True)
resultFile=Path(subprocess.check_output(['xcrun','simctl','get_app_container',args.device,bundle,'data'],text=True).strip())/'Documents/result.txt'
resultFile.unlink(missing_ok=True)
subprocess.run(['xcrun','simctl','launch',args.device,bundle],check=True)
for _ in range(150):
    if resultFile.exists():break
    time.sleep(.2)
assert resultFile.exists(),'No runtime result; inspect simulator crash logs'
result=resultFile.read_text();(out/'result.txt').write_text(result);print(result,flush=True)
subprocess.run(['xcrun','simctl','io',args.device,'screenshot','--display='+args.display,str(out/'toolbar.png')],check=True)
assert result.startswith('PASS:'),result
