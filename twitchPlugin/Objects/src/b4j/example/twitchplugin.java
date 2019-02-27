package b4j.example;


import anywheresoftware.b4a.BA;
import anywheresoftware.b4a.B4AClass;

public class twitchplugin extends B4AClass.ImplB4AClass implements BA.SubDelegator{
    public static java.util.HashMap<String, java.lang.reflect.Method> htSubs;
    private void innerInitialize(BA _ba) throws Exception {
        if (ba == null) {
            ba = new  anywheresoftware.b4a.StandardBA("b4j.example", "b4j.example.twitchplugin", this);
            if (htSubs == null) {
                ba.loadHtSubs(this.getClass());
                htSubs = ba.htSubs;
            }
            ba.htSubs = htSubs;
             
        }
        if (BA.isShellModeRuntimeCheck(ba))
                this.getClass().getMethod("_class_globals", b4j.example.twitchplugin.class).invoke(this, new Object[] {null});
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
public String _appname = "";
public String _appversion = "";
public int _tickinterval = 0;
public int _needdownloads = 0;
public int _updateinterval = 0;
public boolean _lockapp = false;
public String _description = "";
public String _setupinfos = "";
public anywheresoftware.b4a.objects.collections.Map _appsettings = null;
public int[] _icon = null;
public int[] _icon2 = null;
public String _profile = "";
public String _clientid = "";
public String _followers = "";
public String _viewers = "";
public boolean _isstreaming = false;
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
 //BA.debugLineNum = 9;BA.debugLine="Private AppName As String = \"twitch\" 'change plug";
_appname = "twitch";
 //BA.debugLineNum = 10;BA.debugLine="Private AppVersion As String=\"1.2\"";
_appversion = "1.2";
 //BA.debugLineNum = 11;BA.debugLine="Private tickInterval As Int= 65";
_tickinterval = (int) (65);
 //BA.debugLineNum = 12;BA.debugLine="Private needDownloads As Int = 2";
_needdownloads = (int) (2);
 //BA.debugLineNum = 13;BA.debugLine="Private updateInterval As Int = 0 'force update a";
_updateinterval = (int) (0);
 //BA.debugLineNum = 14;BA.debugLine="Private lockApp As Boolean=False";
_lockapp = __c.False;
 //BA.debugLineNum = 17;BA.debugLine="Private description As String= $\" 	Shows your Twi";
_description = ("\n"+"	Shows your Twitch subscriber count or your live viewers while youre streaming<br />\n"+"	<small>Created by AWTRIX</small>\n"+"	");
 //BA.debugLineNum = 22;BA.debugLine="Private setupInfos As String= $\" 	<b>ClientID:</b";
_setupinfos = ("\n"+"	<b>ClientID:</b>  To get a client ID, register your application on the Twitch dev portal (https://glass.twitch.tv/console/apps/create).\n"+"	<b>Profile:</b>  Your Twitch profile name.\n"+"	");
 //BA.debugLineNum = 27;BA.debugLine="Private appSettings As Map = CreateMap(\"Profile\":";
_appsettings = new anywheresoftware.b4a.objects.collections.Map();
_appsettings = __c.createMap(new Object[] {(Object)("Profile"),__c.Null,(Object)("ClientID"),__c.Null});
 //BA.debugLineNum = 29;BA.debugLine="Dim icon() As Int = Array As Int(0x0, 0x49af, 0x4";
_icon = new int[]{(int) (0x0),(int) (0x49af),(int) (0x49af),(int) (0x49af),(int) (0x49af),(int) (0x49af),(int) (0x49af),(int) (0x49af),(int) (0x49af),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0x49af),(int) (0x49af),(int) (0xffff),(int) (0xffff),(int) (0x49af),(int) (0xffff),(int) (0x49af),(int) (0xffff),(int) (0x49af),(int) (0x49af),(int) (0xffff),(int) (0xffff),(int) (0x49af),(int) (0xffff),(int) (0x49af),(int) (0xffff),(int) (0x49af),(int) (0x49af),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0xffff),(int) (0x49af),(int) (0x49af),(int) (0x49af),(int) (0x49af),(int) (0xffff),(int) (0xffff),(int) (0x49af),(int) (0x49af),(int) (0x49af),(int) (0x0),(int) (0x0),(int) (0x49af),(int) (0xffff),(int) (0x49af),(int) (0x0),(int) (0x0),(int) (0x0),(int) (0x0),(int) (0x0),(int) (0x49af),(int) (0x49af),(int) (0x0),(int) (0x0),(int) (0x0),(int) (0x0)};
 //BA.debugLineNum = 30;BA.debugLine="Dim icon2() As Int= Array As Int(0, 33593, 33593,";
_icon2 = new int[]{(int) (0),(int) (33593),(int) (33593),(int) (33593),(int) (33593),(int) (33593),(int) (63488),(int) (63488),(int) (33593),(int) (65535),(int) (65535),(int) (65535),(int) (65535),(int) (65535),(int) (63488),(int) (63488),(int) (33593),(int) (65535),(int) (65535),(int) (33593),(int) (65535),(int) (33593),(int) (65535),(int) (33593),(int) (33593),(int) (65535),(int) (65535),(int) (33593),(int) (65535),(int) (33593),(int) (65535),(int) (33593),(int) (33593),(int) (65535),(int) (65535),(int) (65535),(int) (65535),(int) (65535),(int) (65535),(int) (33593),(int) (33593),(int) (33593),(int) (33593),(int) (65535),(int) (65535),(int) (33593),(int) (33593),(int) (33593),(int) (0),(int) (0),(int) (33593),(int) (65535),(int) (33593),(int) (0),(int) (0),(int) (0),(int) (0),(int) (0),(int) (33593),(int) (33593),(int) (0),(int) (0),(int) (0),(int) (0)};
 //BA.debugLineNum = 31;BA.debugLine="Dim Profile As String";
_profile = "";
 //BA.debugLineNum = 32;BA.debugLine="Dim clientID As String";
_clientid = "";
 //BA.debugLineNum = 33;BA.debugLine="Dim followers As String = \"0\"";
_followers = "0";
 //BA.debugLineNum = 34;BA.debugLine="Dim viewers As String = \"0\"";
_viewers = "0";
 //BA.debugLineNum = 35;BA.debugLine="Dim isStreaming As Boolean";
_isstreaming = false;
 //BA.debugLineNum = 36;BA.debugLine="End Sub";
return "";
}
public boolean  _evaljobresponse(int _nr,boolean _success,String _response,anywheresoftware.b4a.objects.streams.File.InputStreamWrapper _inputstream) throws Exception{
anywheresoftware.b4j.objects.collections.JSONParser _parser = null;
String _res = "";
String _s = "";
anywheresoftware.b4a.objects.collections.Map _root = null;
anywheresoftware.b4a.objects.collections.Map _stream = null;
 //BA.debugLineNum = 147;BA.debugLine="Sub evalJobResponse(nr As Int,success As Boolean,r";
 //BA.debugLineNum = 148;BA.debugLine="If success=False Then Return False";
if (_success==__c.False) { 
if (true) return __c.False;};
 //BA.debugLineNum = 149;BA.debugLine="Select nr";
switch (_nr) {
case 1: {
 //BA.debugLineNum = 151;BA.debugLine="isStreaming=False";
_isstreaming = __c.False;
 //BA.debugLineNum = 152;BA.debugLine="Try";
try { //BA.debugLineNum = 153;BA.debugLine="Dim parser As JSONParser";
_parser = new anywheresoftware.b4j.objects.collections.JSONParser();
 //BA.debugLineNum = 154;BA.debugLine="Dim res As String =response";
_res = _response;
 //BA.debugLineNum = 155;BA.debugLine="Dim s As String=res.SubString(res.IndexOf(\"(\")";
_s = _res.substring((int) (_res.indexOf("(")+1)).replace(")","");
 //BA.debugLineNum = 156;BA.debugLine="parser.Initialize(s)";
_parser.Initialize(_s);
 //BA.debugLineNum = 157;BA.debugLine="Dim root As Map = parser.NextObject";
_root = new anywheresoftware.b4a.objects.collections.Map();
_root = _parser.NextObject();
 //BA.debugLineNum = 159;BA.debugLine="If root.Get(\"stream\") Is Map Then";
if (_root.Get((Object)("stream")) instanceof anywheresoftware.b4a.objects.collections.Map.MyMap) { 
 //BA.debugLineNum = 160;BA.debugLine="isStreaming=True";
_isstreaming = __c.True;
 //BA.debugLineNum = 161;BA.debugLine="Dim stream As Map = root.Get(\"stream\")";
_stream = new anywheresoftware.b4a.objects.collections.Map();
_stream.setObject((anywheresoftware.b4a.objects.collections.Map.MyMap)(_root.Get((Object)("stream"))));
 //BA.debugLineNum = 162;BA.debugLine="viewers = stream.Get(\"viewers\")";
_viewers = BA.ObjectToString(_stream.Get((Object)("viewers")));
 };
 //BA.debugLineNum = 166;BA.debugLine="Return True";
if (true) return __c.True;
 } 
       catch (Exception e18) {
			ba.setLastException(e18); //BA.debugLineNum = 168;BA.debugLine="Log(\"Error in: \"& AppName & CRLF & LastExcepti";
__c.Log("Error in: "+_appname+__c.CRLF+BA.ObjectToString(__c.LastException(ba)));
 //BA.debugLineNum = 169;BA.debugLine="Log(\"API response: \" & CRLF & LastException)";
__c.Log("API response: "+__c.CRLF+BA.ObjectToString(__c.LastException(ba)));
 };
 break; }
case 2: {
 //BA.debugLineNum = 172;BA.debugLine="Try";
try { //BA.debugLineNum = 173;BA.debugLine="Dim parser As JSONParser";
_parser = new anywheresoftware.b4j.objects.collections.JSONParser();
 //BA.debugLineNum = 174;BA.debugLine="Dim res As String =response";
_res = _response;
 //BA.debugLineNum = 175;BA.debugLine="Dim s As String=res.SubString(res.IndexOf(\"(\")";
_s = _res.substring((int) (_res.indexOf("(")+1)).replace(")","");
 //BA.debugLineNum = 176;BA.debugLine="parser.Initialize(s)";
_parser.Initialize(_s);
 //BA.debugLineNum = 177;BA.debugLine="Dim root As Map = parser.NextObject";
_root = new anywheresoftware.b4a.objects.collections.Map();
_root = _parser.NextObject();
 //BA.debugLineNum = 178;BA.debugLine="followers= root.Get(\"followers\")";
_followers = BA.ObjectToString(_root.Get((Object)("followers")));
 //BA.debugLineNum = 179;BA.debugLine="Return True";
if (true) return __c.True;
 } 
       catch (Exception e31) {
			ba.setLastException(e31); //BA.debugLineNum = 181;BA.debugLine="Log(\"Error in: \"& AppName & CRLF & LastExcepti";
__c.Log("Error in: "+_appname+__c.CRLF+BA.ObjectToString(__c.LastException(ba)));
 //BA.debugLineNum = 182;BA.debugLine="Log(\"API response: \" & CRLF & LastException)";
__c.Log("API response: "+__c.CRLF+BA.ObjectToString(__c.LastException(ba)));
 };
 break; }
}
;
 //BA.debugLineNum = 187;BA.debugLine="Return False";
if (true) return __c.False;
 //BA.debugLineNum = 188;BA.debugLine="End Sub";
return false;
}
public anywheresoftware.b4a.objects.collections.List  _genframe() throws Exception{
 //BA.debugLineNum = 190;BA.debugLine="Sub genFrame As List";
 //BA.debugLineNum = 191;BA.debugLine="If isStreaming Then";
if (_isstreaming) { 
 //BA.debugLineNum = 192;BA.debugLine="commandList.Add(genText(viewers))			'Fügt einen";
_commandlist.Add((Object)(_gentext(_viewers).getObject()));
 //BA.debugLineNum = 193;BA.debugLine="commandList.Add(CreateMap(\"type\":\"bmp\",\"x\":0,\"y\"";
_commandlist.Add((Object)(__c.createMap(new Object[] {(Object)("type"),(Object)("bmp"),(Object)("x"),(Object)(0),(Object)("y"),(Object)(0),(Object)("bmp"),(Object)(_icon2),(Object)("width"),(Object)(8),(Object)("height"),(Object)(8)}).getObject()));
 }else {
 //BA.debugLineNum = 195;BA.debugLine="commandList.Add(genText(followers))			'Fügt eine";
_commandlist.Add((Object)(_gentext(_followers).getObject()));
 //BA.debugLineNum = 196;BA.debugLine="commandList.Add(CreateMap(\"type\":\"bmp\",\"x\":0,\"y\"";
_commandlist.Add((Object)(__c.createMap(new Object[] {(Object)("type"),(Object)("bmp"),(Object)("x"),(Object)(0),(Object)("y"),(Object)(0),(Object)("bmp"),(Object)(_icon),(Object)("width"),(Object)(8),(Object)("height"),(Object)(8)}).getObject()));
 };
 //BA.debugLineNum = 199;BA.debugLine="Return commandList";
if (true) return _commandlist;
 //BA.debugLineNum = 200;BA.debugLine="End Sub";
return null;
}
public anywheresoftware.b4a.objects.collections.Map  _gentext(String _s) throws Exception{
anywheresoftware.b4a.objects.collections.Map _command = null;
 //BA.debugLineNum = 202;BA.debugLine="Sub genText(s As String) As Map";
 //BA.debugLineNum = 203;BA.debugLine="If s.Length>5 Then";
if (_s.length()>5) { 
 //BA.debugLineNum = 204;BA.debugLine="Dim command As Map=CreateMap(\"type\":\"text\",\"text";
_command = new anywheresoftware.b4a.objects.collections.Map();
_command = __c.createMap(new Object[] {(Object)("type"),(Object)("text"),(Object)("text"),(Object)(_s),(Object)("x"),(Object)(_scrollposition),(Object)("y"),(Object)(1),(Object)("font"),(Object)("auto")});
 //BA.debugLineNum = 205;BA.debugLine="scrollposition=scrollposition-1";
_scrollposition = (int) (_scrollposition-1);
 //BA.debugLineNum = 206;BA.debugLine="If scrollposition< 0-(s.Length*4)  Then";
if (_scrollposition<0-(_s.length()*4)) { 
 //BA.debugLineNum = 207;BA.debugLine="If lockApp Then";
if (_lockapp) { 
 //BA.debugLineNum = 208;BA.debugLine="Dim command As Map=CreateMap(\"type\":\"finish\")";
_command = new anywheresoftware.b4a.objects.collections.Map();
_command = __c.createMap(new Object[] {(Object)("type"),(Object)("finish")});
 //BA.debugLineNum = 209;BA.debugLine="Return command";
if (true) return _command;
 }else {
 //BA.debugLineNum = 211;BA.debugLine="scrollposition=32";
_scrollposition = (int) (32);
 };
 };
 }else {
 //BA.debugLineNum = 215;BA.debugLine="Dim command As Map=CreateMap(\"type\":\"text\",\"text";
_command = new anywheresoftware.b4a.objects.collections.Map();
_command = __c.createMap(new Object[] {(Object)("type"),(Object)("text"),(Object)("text"),(Object)(_s),(Object)("x"),(Object)(9),(Object)("y"),(Object)(1),(Object)("font"),(Object)("auto")});
 };
 //BA.debugLineNum = 218;BA.debugLine="Return command";
if (true) return _command;
 //BA.debugLineNum = 219;BA.debugLine="End Sub";
return null;
}
public String  _getnicename() throws Exception{
 //BA.debugLineNum = 49;BA.debugLine="public Sub GetNiceName() As String";
 //BA.debugLineNum = 50;BA.debugLine="Return AppName";
if (true) return _appname;
 //BA.debugLineNum = 51;BA.debugLine="End Sub";
return "";
}
public String  _initialize(anywheresoftware.b4a.BA _ba) throws Exception{
innerInitialize(_ba);
 //BA.debugLineNum = 39;BA.debugLine="Public Sub Initialize() As String";
 //BA.debugLineNum = 40;BA.debugLine="commandList.Initialize";
_commandlist.Initialize();
 //BA.debugLineNum = 41;BA.debugLine="MainSettings.Initialize";
_mainsettings.Initialize();
 //BA.debugLineNum = 42;BA.debugLine="MainSettings.Put(\"interval\",tickInterval)";
_mainsettings.Put((Object)("interval"),(Object)(_tickinterval));
 //BA.debugLineNum = 43;BA.debugLine="MainSettings.Put(\"needDownload\",needDownloads)";
_mainsettings.Put((Object)("needDownload"),(Object)(_needdownloads));
 //BA.debugLineNum = 44;BA.debugLine="setSettings";
_setsettings();
 //BA.debugLineNum = 45;BA.debugLine="Return \"MyKey\"";
if (true) return "MyKey";
 //BA.debugLineNum = 46;BA.debugLine="End Sub";
return "";
}
public Object  _run(String _tag,anywheresoftware.b4a.objects.collections.Map _params) throws Exception{
anywheresoftware.b4a.objects.collections.Map _infos = null;
byte[] _data = null;
anywheresoftware.b4a.objects.streams.File.InputStreamWrapper _in = null;
anywheresoftware.b4a.objects.streams.File.OutputStreamWrapper _out = null;
boolean _isconfigured = false;
anywheresoftware.b4a.objects.collections.Map _m = null;
Object _v = null;
 //BA.debugLineNum = 54;BA.debugLine="public Sub Run(Tag As String, Params As Map) As Ob";
 //BA.debugLineNum = 55;BA.debugLine="Select Case Tag";
switch (BA.switchObjectToInt(_tag,"start","downloadCount","startDownload","httpResponse","tick","infos","setSettings","getUpdateInterval")) {
case 0: {
 //BA.debugLineNum = 57;BA.debugLine="If Params.ContainsKey(\"AppDuration\") Then";
if (_params.ContainsKey((Object)("AppDuration"))) { 
 //BA.debugLineNum = 58;BA.debugLine="Appduration = Params.Get(\"AppDuration\")";
_appduration = (int)(BA.ObjectToNumber(_params.Get((Object)("AppDuration"))));
 };
 //BA.debugLineNum = 60;BA.debugLine="scrollposition=32";
_scrollposition = (int) (32);
 //BA.debugLineNum = 61;BA.debugLine="Return MainSettings";
if (true) return (Object)(_mainsettings.getObject());
 break; }
case 1: {
 //BA.debugLineNum = 63;BA.debugLine="Return needDownloads";
if (true) return (Object)(_needdownloads);
 break; }
case 2: {
 //BA.debugLineNum = 65;BA.debugLine="Return startDownload(Params.Get(\"jobNr\"))";
if (true) return (Object)(_startdownload((int)(BA.ObjectToNumber(_params.Get((Object)("jobNr"))))));
 break; }
case 3: {
 //BA.debugLineNum = 67;BA.debugLine="Return evalJobResponse(Params.Get(\"jobNr\"),Para";
if (true) return (Object)(_evaljobresponse((int)(BA.ObjectToNumber(_params.Get((Object)("jobNr")))),BA.ObjectToBoolean(_params.Get((Object)("success"))),BA.ObjectToString(_params.Get((Object)("response"))),(anywheresoftware.b4a.objects.streams.File.InputStreamWrapper) anywheresoftware.b4a.AbsObjectWrapper.ConvertToWrapper(new anywheresoftware.b4a.objects.streams.File.InputStreamWrapper(), (java.io.InputStream)(_params.Get((Object)("InputStream"))))));
 break; }
case 4: {
 //BA.debugLineNum = 69;BA.debugLine="commandList.Clear											'Wird in der einges";
_commandlist.Clear();
 //BA.debugLineNum = 70;BA.debugLine="Return genFrame";
if (true) return (Object)(_genframe().getObject());
 break; }
case 5: {
 //BA.debugLineNum = 72;BA.debugLine="Dim infos As Map";
_infos = new anywheresoftware.b4a.objects.collections.Map();
 //BA.debugLineNum = 73;BA.debugLine="infos.Initialize";
_infos.Initialize();
 //BA.debugLineNum = 74;BA.debugLine="Dim data() As Byte";
_data = new byte[(int) (0)];
;
 //BA.debugLineNum = 75;BA.debugLine="If File.Exists(File.Combine(File.DirApp,\"plugi";
if (__c.File.Exists(__c.File.Combine(__c.File.getDirApp(),"plugins"),_appname+".png")) { 
 //BA.debugLineNum = 76;BA.debugLine="Dim in As InputStream";
_in = new anywheresoftware.b4a.objects.streams.File.InputStreamWrapper();
 //BA.debugLineNum = 77;BA.debugLine="in = File.OpenInput(File.Combine(File.DirApp,\"";
_in = __c.File.OpenInput(__c.File.Combine(__c.File.getDirApp(),"plugins"),_appname+".png");
 //BA.debugLineNum = 78;BA.debugLine="Dim out As OutputStream";
_out = new anywheresoftware.b4a.objects.streams.File.OutputStreamWrapper();
 //BA.debugLineNum = 79;BA.debugLine="out.InitializeToBytesArray(1000)";
_out.InitializeToBytesArray((int) (1000));
 //BA.debugLineNum = 80;BA.debugLine="File.Copy2(in, out)";
__c.File.Copy2((java.io.InputStream)(_in.getObject()),(java.io.OutputStream)(_out.getObject()));
 //BA.debugLineNum = 81;BA.debugLine="data = out.ToBytesArray";
_data = _out.ToBytesArray();
 //BA.debugLineNum = 82;BA.debugLine="out.Close";
_out.Close();
 };
 //BA.debugLineNum = 84;BA.debugLine="infos.Put(\"pic\",data)";
_infos.Put((Object)("pic"),(Object)(_data));
 //BA.debugLineNum = 85;BA.debugLine="Dim isconfigured As Boolean=True";
_isconfigured = __c.True;
 //BA.debugLineNum = 86;BA.debugLine="If File.Exists(File.Combine(File.DirApp,\"plugin";
if (__c.File.Exists(__c.File.Combine(__c.File.getDirApp(),"plugins"),_appname+".ax")) { 
 //BA.debugLineNum = 87;BA.debugLine="Dim m As Map = File.ReadMap(File.Combine(File.D";
_m = new anywheresoftware.b4a.objects.collections.Map();
_m = __c.File.ReadMap(__c.File.Combine(__c.File.getDirApp(),"plugins"),_appname+".ax");
 //BA.debugLineNum = 88;BA.debugLine="For Each v As Object In m.Values";
{
final anywheresoftware.b4a.BA.IterableList group34 = _m.Values();
final int groupLen34 = group34.getSize()
;int index34 = 0;
;
for (; index34 < groupLen34;index34++){
_v = group34.Get(index34);
 //BA.debugLineNum = 89;BA.debugLine="If v=\"null\" Then";
if ((_v).equals((Object)("null"))) { 
 //BA.debugLineNum = 90;BA.debugLine="isconfigured=False";
_isconfigured = __c.False;
 };
 }
};
 };
 //BA.debugLineNum = 94;BA.debugLine="infos.Put(\"isconfigured\",isconfigured)";
_infos.Put((Object)("isconfigured"),(Object)(_isconfigured));
 //BA.debugLineNum = 95;BA.debugLine="infos.Put(\"AppVersion\",AppVersion)";
_infos.Put((Object)("AppVersion"),(Object)(_appversion));
 //BA.debugLineNum = 96;BA.debugLine="infos.Put(\"description\",description)";
_infos.Put((Object)("description"),(Object)(_description));
 //BA.debugLineNum = 97;BA.debugLine="infos.Put(\"setupInfos\",setupInfos)";
_infos.Put((Object)("setupInfos"),(Object)(_setupinfos));
 //BA.debugLineNum = 98;BA.debugLine="Return infos";
if (true) return (Object)(_infos.getObject());
 break; }
case 6: {
 //BA.debugLineNum = 100;BA.debugLine="Return setSettings";
if (true) return (Object)(_setsettings());
 break; }
case 7: {
 //BA.debugLineNum = 102;BA.debugLine="Return updateInterval";
if (true) return (Object)(_updateinterval);
 break; }
}
;
 //BA.debugLineNum = 104;BA.debugLine="Return True";
if (true) return (Object)(__c.True);
 //BA.debugLineNum = 105;BA.debugLine="End Sub";
return null;
}
public boolean  _setsettings() throws Exception{
anywheresoftware.b4a.objects.collections.Map _m = null;
String _k = "";
 //BA.debugLineNum = 110;BA.debugLine="Sub setSettings As Boolean";
 //BA.debugLineNum = 111;BA.debugLine="If File.Exists(File.Combine(File.DirApp,\"plugins\"";
if (__c.File.Exists(__c.File.Combine(__c.File.getDirApp(),"plugins"),_appname+".ax")) { 
 //BA.debugLineNum = 112;BA.debugLine="Dim m As Map = File.ReadMap(File.Combine(File.Di";
_m = new anywheresoftware.b4a.objects.collections.Map();
_m = __c.File.ReadMap(__c.File.Combine(__c.File.getDirApp(),"plugins"),_appname+".ax");
 //BA.debugLineNum = 113;BA.debugLine="For Each k As String In appSettings.Keys";
{
final anywheresoftware.b4a.BA.IterableList group3 = _appsettings.Keys();
final int groupLen3 = group3.getSize()
;int index3 = 0;
;
for (; index3 < groupLen3;index3++){
_k = BA.ObjectToString(group3.Get(index3));
 //BA.debugLineNum = 114;BA.debugLine="If Not(m.ContainsKey(k)) Then m.Put(k,appSettin";
if (__c.Not(_m.ContainsKey((Object)(_k)))) { 
_m.Put((Object)(_k),_appsettings.Get((Object)(_k)));};
 }
};
 //BA.debugLineNum = 116;BA.debugLine="File.WriteMap(File.Combine(File.DirApp,\"plugins\"";
__c.File.WriteMap(__c.File.Combine(__c.File.getDirApp(),"plugins"),_appname+".ax",_m);
 //BA.debugLineNum = 117;BA.debugLine="updateInterval=m.Get(\"updateInterval\")";
_updateinterval = (int)(BA.ObjectToNumber(_m.Get((Object)("updateInterval"))));
 //BA.debugLineNum = 119;BA.debugLine="Profile=m.Get(\"Profile\")";
_profile = BA.ObjectToString(_m.Get((Object)("Profile")));
 //BA.debugLineNum = 120;BA.debugLine="clientID=m.Get(\"ClientID\")";
_clientid = BA.ObjectToString(_m.Get((Object)("ClientID")));
 }else {
 //BA.debugLineNum = 122;BA.debugLine="Dim m As Map";
_m = new anywheresoftware.b4a.objects.collections.Map();
 //BA.debugLineNum = 123;BA.debugLine="m.Initialize";
_m.Initialize();
 //BA.debugLineNum = 124;BA.debugLine="m.Put(\"updateInterval\",updateInterval)";
_m.Put((Object)("updateInterval"),(Object)(_updateinterval));
 //BA.debugLineNum = 125;BA.debugLine="For Each k As String In appSettings.Keys";
{
final anywheresoftware.b4a.BA.IterableList group14 = _appsettings.Keys();
final int groupLen14 = group14.getSize()
;int index14 = 0;
;
for (; index14 < groupLen14;index14++){
_k = BA.ObjectToString(group14.Get(index14));
 //BA.debugLineNum = 126;BA.debugLine="m.Put(k,appSettings.Get(k))";
_m.Put((Object)(_k),_appsettings.Get((Object)(_k)));
 }
};
 //BA.debugLineNum = 128;BA.debugLine="File.WriteMap(File.Combine(File.DirApp,\"plugins\"";
__c.File.WriteMap(__c.File.Combine(__c.File.getDirApp(),"plugins"),_appname+".ax",_m);
 };
 //BA.debugLineNum = 130;BA.debugLine="Return True";
if (true) return __c.True;
 //BA.debugLineNum = 131;BA.debugLine="End Sub";
return false;
}
public String  _startdownload(int _nr) throws Exception{
String _url = "";
 //BA.debugLineNum = 134;BA.debugLine="Sub startDownload(nr As Int) As String";
 //BA.debugLineNum = 135;BA.debugLine="Dim URL As String";
_url = "";
 //BA.debugLineNum = 136;BA.debugLine="Select nr";
switch (_nr) {
case 1: {
 //BA.debugLineNum = 138;BA.debugLine="URL=(\"https://api.twitch.tv/kraken/streams/\"&Pr";
_url = ("https://api.twitch.tv/kraken/streams/"+_profile+"?client_id="+_clientid);
 break; }
case 2: {
 //BA.debugLineNum = 141;BA.debugLine="URL=(\"https://api.twitch.tv/kraken/channels/\"&P";
_url = ("https://api.twitch.tv/kraken/channels/"+_profile+"?client_id="+_clientid+"&callback=null");
 break; }
}
;
 //BA.debugLineNum = 143;BA.debugLine="Return URL";
if (true) return _url;
 //BA.debugLineNum = 144;BA.debugLine="End Sub";
return "";
}
public Object callSub(String sub, Object sender, Object[] args) throws Exception {
BA.senderHolder.set(sender);
return BA.SubDelegator.SubNotFound;
}
}
