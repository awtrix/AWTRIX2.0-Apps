package b4j.example;


import anywheresoftware.b4a.BA;
import anywheresoftware.b4a.B4AClass;
import anywheresoftware.b4a.debug.*;

public class mqttplugin extends B4AClass.ImplB4AClass implements BA.SubDelegator{
    public static java.util.HashMap<String, java.lang.reflect.Method> htSubs;
    private void innerInitialize(BA _ba) throws Exception {
        if (ba == null) {
            ba = new  anywheresoftware.b4a.StandardBA("b4j.example", "b4j.example.mqttplugin", this);
            if (htSubs == null) {
                ba.loadHtSubs(this.getClass());
                htSubs = ba.htSubs;
            }
            ba.htSubs = htSubs;
             
        }
        if (BA.isShellModeRuntimeCheck(ba))
                this.getClass().getMethod("_class_globals", b4j.example.mqttplugin.class).invoke(this, new Object[] {null});
        else
            ba.raiseEvent2(null, true, "class_globals", false);
    }

 public anywheresoftware.b4a.keywords.Common __c = null;
public anywheresoftware.b4a.objects.collections.Map _mainsettings = null;
public anywheresoftware.b4a.objects.collections.Map _settings = null;
public int _scrollposition = 0;
public anywheresoftware.b4a.objects.collections.List _commandlist = null;
public Object _callerobject = null;
public int _appduration = 0;
public int[] _icon = null;
public String _pluginname = "";
public int _tickinterval = 0;
public int _needdownloads = 0;
public int _updateinterval = 0;
public String _mqtttopic = "";
public String _description = "";
public String[] _settingsids = null;
public String _topicvalue = "";
public b4j.example.httputils2service _httputils2service = null;
public String  _class_globals() throws Exception{
 //BA.debugLineNum = 1;BA.debugLine="Sub Class_Globals";
 //BA.debugLineNum = 2;BA.debugLine="Dim MainSettings As Map 'ignore";
_mainsettings = new anywheresoftware.b4a.objects.collections.Map();
 //BA.debugLineNum = 3;BA.debugLine="Private settings As Map 'ignore";
_settings = new anywheresoftware.b4a.objects.collections.Map();
 //BA.debugLineNum = 4;BA.debugLine="Dim scrollposition As Int 'ignore";
_scrollposition = 0;
 //BA.debugLineNum = 5;BA.debugLine="Dim commandList As List 'ignore";
_commandlist = new anywheresoftware.b4a.objects.collections.List();
 //BA.debugLineNum = 6;BA.debugLine="Dim CallerObject As Object 'ignore";
_callerobject = new Object();
 //BA.debugLineNum = 7;BA.debugLine="Dim Appduration As Int 'ignore";
_appduration = 0;
 //BA.debugLineNum = 9;BA.debugLine="Dim icon() As Int = Array As Int(0x0, 0x0, 0x0, 0";
_icon = new int[]{(int) (0x0),(int) (0x0),(int) (0x0),(int) (0x0),(int) (0x0),(int) (0x0),(int) (0x0),(int) (0x0),(int) (0x0),(int) (0x0),(int) (0x0),(int) (0x0),(int) (0xe73c),(int) (0xe73c),(int) (0xe73c),(int) (0x0),(int) (0x0),(int) (0x0),(int) (0x0),(int) (0xe73c),(int) (0xe73c),(int) (0xe73c),(int) (0xe73c),(int) (0xe73c),(int) (0x0),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xe73c),(int) (0xe73c),(int) (0xe73c),(int) (0xe73c),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xe73c),(int) (0xe73c),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff)};
 //BA.debugLineNum = 10;BA.debugLine="Private PluginName As String = \"mqtt\" 'plugin nam";
_pluginname = "mqtt";
 //BA.debugLineNum = 11;BA.debugLine="Private tickInterval As Int= 60 'tick rate in ms";
_tickinterval = (int) (60);
 //BA.debugLineNum = 12;BA.debugLine="Private needDownloads As Int = 0 'how many dowloa";
_needdownloads = (int) (0);
 //BA.debugLineNum = 13;BA.debugLine="Private updateInterval As Int = 0 'force update a";
_updateinterval = (int) (0);
 //BA.debugLineNum = 14;BA.debugLine="Private mqttTopic As String = \"test\"";
_mqtttopic = "test";
 //BA.debugLineNum = 17;BA.debugLine="Private description As String= $\" 	Get data via M";
_description = ("\n"+"	Get data via MQTT.<br />\n"+"	<small>Created by AWTRIX</small>\n"+"	");
 //BA.debugLineNum = 22;BA.debugLine="Private settingsIds() As String = Array As String";
_settingsids = new String[]{};
 //BA.debugLineNum = 25;BA.debugLine="Dim topicValue As String";
_topicvalue = "";
 //BA.debugLineNum = 27;BA.debugLine="End Sub";
return "";
}
public String  _evaljobresponse(int _nr,b4j.example.httpjob _job) throws Exception{
 //BA.debugLineNum = 127;BA.debugLine="Sub evalJobResponse(nr As Int,job As HttpJob)";
 //BA.debugLineNum = 128;BA.debugLine="If Not(job.JobName=PluginName) Then Return";
if (__c.Not((_job._jobname).equals(_pluginname))) { 
if (true) return "";};
 //BA.debugLineNum = 129;BA.debugLine="Select nr";
switch (BA.switchObjectToInt(_nr,(int)(Double.parseDouble("1")))) {
case 0: {
 //BA.debugLineNum = 131;BA.debugLine="If job.Success Then";
if (_job._success) { 
 };
 break; }
}
;
 //BA.debugLineNum = 135;BA.debugLine="End Sub";
return "";
}
public anywheresoftware.b4a.objects.collections.List  _genframe() throws Exception{
 //BA.debugLineNum = 139;BA.debugLine="Sub genFrame As List";
 //BA.debugLineNum = 140;BA.debugLine="commandList.Add(genText(topicValue))";
_commandlist.Add((Object)(_gentext(_topicvalue).getObject()));
 //BA.debugLineNum = 141;BA.debugLine="commandList.Add(CreateMap(\"type\":\"bmp\",\"x\":0,\"y\":";
_commandlist.Add((Object)(__c.createMap(new Object[] {(Object)("type"),(Object)("bmp"),(Object)("x"),(Object)(0),(Object)("y"),(Object)(0),(Object)("bmp"),(Object)(_icon),(Object)("width"),(Object)(8),(Object)("height"),(Object)(8)}).getObject()));
 //BA.debugLineNum = 142;BA.debugLine="Return commandList";
if (true) return _commandlist;
 //BA.debugLineNum = 143;BA.debugLine="End Sub";
return null;
}
public anywheresoftware.b4a.objects.collections.Map  _gentext(String _s) throws Exception{
anywheresoftware.b4a.objects.collections.Map _command = null;
 //BA.debugLineNum = 146;BA.debugLine="Sub genText(s As String) As Map";
 //BA.debugLineNum = 147;BA.debugLine="If s.Length>5 Then";
if (_s.length()>5) { 
 //BA.debugLineNum = 148;BA.debugLine="Dim command As Map=CreateMap(\"type\":\"text\",\"text";
_command = new anywheresoftware.b4a.objects.collections.Map();
_command = __c.createMap(new Object[] {(Object)("type"),(Object)("text"),(Object)("text"),(Object)(_s),(Object)("x"),(Object)(_scrollposition),(Object)("y"),(Object)(1),(Object)("font"),(Object)("auto")});
 //BA.debugLineNum = 149;BA.debugLine="scrollposition=scrollposition-1";
_scrollposition = (int) (_scrollposition-1);
 //BA.debugLineNum = 150;BA.debugLine="If scrollposition< 0-(s.Length*6)  Then";
if (_scrollposition<0-(_s.length()*6)) { 
 //BA.debugLineNum = 151;BA.debugLine="scrollposition=32";
_scrollposition = (int) (32);
 };
 }else {
 //BA.debugLineNum = 154;BA.debugLine="Dim command As Map=CreateMap(\"type\":\"text\",\"text";
_command = new anywheresoftware.b4a.objects.collections.Map();
_command = __c.createMap(new Object[] {(Object)("type"),(Object)("text"),(Object)("text"),(Object)(_s),(Object)("x"),(Object)(9),(Object)("y"),(Object)(1),(Object)("font"),(Object)("auto")});
 };
 //BA.debugLineNum = 157;BA.debugLine="Return command";
if (true) return _command;
 //BA.debugLineNum = 158;BA.debugLine="End Sub";
return null;
}
public String  _getnicename() throws Exception{
 //BA.debugLineNum = 40;BA.debugLine="public Sub GetNiceName() As String";
 //BA.debugLineNum = 41;BA.debugLine="Return PluginName";
if (true) return _pluginname;
 //BA.debugLineNum = 42;BA.debugLine="End Sub";
return "";
}
public String  _initialize(anywheresoftware.b4a.BA _ba) throws Exception{
innerInitialize(_ba);
 //BA.debugLineNum = 30;BA.debugLine="Public Sub Initialize() As String";
 //BA.debugLineNum = 31;BA.debugLine="MainSettings.Initialize";
_mainsettings.Initialize();
 //BA.debugLineNum = 32;BA.debugLine="MainSettings.Put(\"interval\",tickInterval)";
_mainsettings.Put((Object)("interval"),(Object)(_tickinterval));
 //BA.debugLineNum = 33;BA.debugLine="MainSettings.Put(\"needDownload\",needDownloads)";
_mainsettings.Put((Object)("needDownload"),(Object)(_needdownloads));
 //BA.debugLineNum = 34;BA.debugLine="MainSettings.Put(\"mqttTopic\",mqttTopic)";
_mainsettings.Put((Object)("mqttTopic"),(Object)(_mqtttopic));
 //BA.debugLineNum = 35;BA.debugLine="setSettings";
_setsettings();
 //BA.debugLineNum = 36;BA.debugLine="Return \"MyKey\"";
if (true) return "MyKey";
 //BA.debugLineNum = 37;BA.debugLine="End Sub";
return "";
}
public Object  _run(String _tag,anywheresoftware.b4a.objects.collections.Map _params) throws Exception{
Object[] _infos = null;
byte[] _data = null;
anywheresoftware.b4a.objects.streams.File.InputStreamWrapper _in = null;
anywheresoftware.b4a.objects.streams.File.OutputStreamWrapper _out = null;
boolean _isconfigured = false;
anywheresoftware.b4a.objects.collections.Map _m = null;
Object _v = null;
 //BA.debugLineNum = 45;BA.debugLine="public Sub Run(Tag As String, Params As Map) As Ob";
 //BA.debugLineNum = 46;BA.debugLine="Select Case Tag";
switch (BA.switchObjectToInt(_tag,"start","download","httpResponse","tick","infos","setSettings","mqtt","getUpdateInterval")) {
case 0: {
 //BA.debugLineNum = 48;BA.debugLine="If Params.ContainsKey(\"AppDuration\") Then";
if (_params.ContainsKey((Object)("AppDuration"))) { 
 //BA.debugLineNum = 49;BA.debugLine="Appduration = Params.Get(\"AppDuration\")";
_appduration = (int)(BA.ObjectToNumber(_params.Get((Object)("AppDuration"))));
 };
 //BA.debugLineNum = 51;BA.debugLine="scrollposition=32";
_scrollposition = (int) (32);
 //BA.debugLineNum = 52;BA.debugLine="Return MainSettings";
if (true) return (Object)(_mainsettings.getObject());
 break; }
case 1: {
 //BA.debugLineNum = 54;BA.debugLine="CallerObject = Params.Get(\"Handler\")";
_callerobject = _params.Get((Object)("Handler"));
 //BA.debugLineNum = 55;BA.debugLine="startDownload(Params.Get(\"jobNr\"))";
_startdownload((int)(BA.ObjectToNumber(_params.Get((Object)("jobNr")))));
 break; }
case 2: {
 //BA.debugLineNum = 57;BA.debugLine="evalJobResponse(Params.Get(\"jobNr\"),Params.Get(";
_evaljobresponse((int)(BA.ObjectToNumber(_params.Get((Object)("jobNr")))),(b4j.example.httpjob)(_params.Get((Object)("response"))));
 break; }
case 3: {
 //BA.debugLineNum = 59;BA.debugLine="commandList.Initialize											'Wird in der e";
_commandlist.Initialize();
 //BA.debugLineNum = 60;BA.debugLine="Return genFrame";
if (true) return (Object)(_genframe().getObject());
 break; }
case 4: {
 //BA.debugLineNum = 62;BA.debugLine="Dim infos(3) As Object";
_infos = new Object[(int) (3)];
{
int d0 = _infos.length;
for (int i0 = 0;i0 < d0;i0++) {
_infos[i0] = new Object();
}
}
;
 //BA.debugLineNum = 63;BA.debugLine="Dim data() As Byte";
_data = new byte[(int) (0)];
;
 //BA.debugLineNum = 64;BA.debugLine="If File.Exists(File.Combine(File.DirApp,\"plugin";
if (__c.File.Exists(__c.File.Combine(__c.File.getDirApp(),"plugins"),_pluginname+".png")) { 
 //BA.debugLineNum = 65;BA.debugLine="Dim in As InputStream";
_in = new anywheresoftware.b4a.objects.streams.File.InputStreamWrapper();
 //BA.debugLineNum = 66;BA.debugLine="in = File.OpenInput(File.Combine(File.DirApp,\"";
_in = __c.File.OpenInput(__c.File.Combine(__c.File.getDirApp(),"plugins"),_pluginname+".png");
 //BA.debugLineNum = 67;BA.debugLine="Dim out As OutputStream";
_out = new anywheresoftware.b4a.objects.streams.File.OutputStreamWrapper();
 //BA.debugLineNum = 68;BA.debugLine="out.InitializeToBytesArray(1000)";
_out.InitializeToBytesArray((int) (1000));
 //BA.debugLineNum = 69;BA.debugLine="File.Copy2(in, out) '<---- This does the actua";
__c.File.Copy2((java.io.InputStream)(_in.getObject()),(java.io.OutputStream)(_out.getObject()));
 //BA.debugLineNum = 70;BA.debugLine="data = out.ToBytesArray";
_data = _out.ToBytesArray();
 };
 //BA.debugLineNum = 72;BA.debugLine="infos(0)=data";
_infos[(int) (0)] = (Object)(_data);
 //BA.debugLineNum = 73;BA.debugLine="infos(1)=description";
_infos[(int) (1)] = (Object)(_description);
 //BA.debugLineNum = 75;BA.debugLine="Dim isconfigured As Boolean=True";
_isconfigured = __c.True;
 //BA.debugLineNum = 76;BA.debugLine="If File.Exists(File.Combine(File.DirApp,\"plugin";
if (__c.File.Exists(__c.File.Combine(__c.File.getDirApp(),"plugins"),_pluginname+".ax")) { 
 //BA.debugLineNum = 77;BA.debugLine="Dim m As Map = File.ReadMap(File.Combine(File.";
_m = new anywheresoftware.b4a.objects.collections.Map();
_m = __c.File.ReadMap(__c.File.Combine(__c.File.getDirApp(),"plugins"),_pluginname+".ax");
 //BA.debugLineNum = 78;BA.debugLine="For Each v As Object In m.Values";
{
final anywheresoftware.b4a.BA.IterableList group32 = _m.Values();
final int groupLen32 = group32.getSize()
;int index32 = 0;
;
for (; index32 < groupLen32;index32++){
_v = group32.Get(index32);
 //BA.debugLineNum = 79;BA.debugLine="If v=\"null\" Then";
if ((_v).equals((Object)("null"))) { 
 //BA.debugLineNum = 80;BA.debugLine="isconfigured=False";
_isconfigured = __c.False;
 };
 }
};
 };
 //BA.debugLineNum = 85;BA.debugLine="infos(2)=isconfigured";
_infos[(int) (2)] = (Object)(_isconfigured);
 //BA.debugLineNum = 86;BA.debugLine="Return infos";
if (true) return (Object)(_infos);
 break; }
case 5: {
 //BA.debugLineNum = 88;BA.debugLine="setSettings";
_setsettings();
 break; }
case 6: {
 //BA.debugLineNum = 90;BA.debugLine="If Params.ContainsKey(\"topicValue\") Then";
if (_params.ContainsKey((Object)("topicValue"))) { 
 //BA.debugLineNum = 91;BA.debugLine="topicValue = Params.Get(\"topicValue\")";
_topicvalue = BA.ObjectToString(_params.Get((Object)("topicValue")));
 };
 break; }
case 7: {
 //BA.debugLineNum = 94;BA.debugLine="Return updateInterval";
if (true) return (Object)(_updateinterval);
 break; }
}
;
 //BA.debugLineNum = 96;BA.debugLine="End Sub";
return null;
}
public String  _setsettings() throws Exception{
anywheresoftware.b4a.objects.collections.Map _m = null;
int _i = 0;
 //BA.debugLineNum = 100;BA.debugLine="Sub setSettings";
 //BA.debugLineNum = 101;BA.debugLine="If File.Exists(File.Combine(File.DirApp,\"plugins\"";
if (__c.File.Exists(__c.File.Combine(__c.File.getDirApp(),"plugins"),_pluginname+".ax")) { 
 //BA.debugLineNum = 102;BA.debugLine="Dim m As Map = File.ReadMap(File.Combine(File.Di";
_m = new anywheresoftware.b4a.objects.collections.Map();
_m = __c.File.ReadMap(__c.File.Combine(__c.File.getDirApp(),"plugins"),_pluginname+".ax");
 //BA.debugLineNum = 103;BA.debugLine="updateInterval=m.Get(\"updateInterval\")";
_updateinterval = (int)(BA.ObjectToNumber(_m.Get((Object)("updateInterval"))));
 }else {
 //BA.debugLineNum = 107;BA.debugLine="Dim m As Map";
_m = new anywheresoftware.b4a.objects.collections.Map();
 //BA.debugLineNum = 108;BA.debugLine="m.Initialize";
_m.Initialize();
 //BA.debugLineNum = 109;BA.debugLine="m.Put(\"updateInterval\",updateInterval)";
_m.Put((Object)("updateInterval"),(Object)(_updateinterval));
 //BA.debugLineNum = 110;BA.debugLine="For i=0 To settingsIds.Length-1";
{
final int step8 = 1;
final int limit8 = (int) (_settingsids.length-1);
_i = (int) (0) ;
for (;_i <= limit8 ;_i = _i + step8 ) {
 //BA.debugLineNum = 111;BA.debugLine="m.Put(settingsIds(i),Null)";
_m.Put((Object)(_settingsids[_i]),__c.Null);
 }
};
 //BA.debugLineNum = 113;BA.debugLine="File.WriteMap(File.Combine(File.DirApp,\"plugins\"";
__c.File.WriteMap(__c.File.Combine(__c.File.getDirApp(),"plugins"),_pluginname+".ax",_m);
 };
 //BA.debugLineNum = 116;BA.debugLine="End Sub";
return "";
}
public String  _startdownload(int _nr) throws Exception{
 //BA.debugLineNum = 119;BA.debugLine="Sub startDownload(nr As Int)";
 //BA.debugLineNum = 120;BA.debugLine="Select nr";
switch (BA.switchObjectToInt(_nr,(int)(Double.parseDouble("1")))) {
case 0: {
 break; }
}
;
 //BA.debugLineNum = 124;BA.debugLine="End Sub";
return "";
}
public Object callSub(String sub, Object sender, Object[] args) throws Exception {
BA.senderHolder.set(sender);
return BA.SubDelegator.SubNotFound;
}
}
