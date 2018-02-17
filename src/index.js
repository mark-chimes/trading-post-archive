import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

var node = document.getElementById('root');
var app = Main.embed(node);

registerServiceWorker();

app.ports.saveString.subscribe(function(word) {
	save(word);
});

function save(word) {
	download('test.txt', word); // save the item
}

app.ports.callLoad.subscribe(function() {
	load();
});

function load() {
	var uploadLink = document.createElement("input"); 
	uploadLink.setAttribute("type", "file");
	var uploadEvent = document.createEvent('MouseEvents');
    uploadEvent.initEvent('click', true, true);
    uploadLink.dispatchEvent(uploadEvent);
	
	var reader = new FileReader();

	
	uploadLink.onchange = function(fileSelectionEvent) { 
		var file = fileSelectionEvent.target.result;
		reader.readAsText(file);
	};
	
	
	reader.onLoad = (function(fileDoneUploadingEvent) {
		// var newWord = fileDoneUploadingEvent.target.result;
		// app.ports.getString.send(newWord);
	});
	
	
	/*
	document.getElementById('input').onchange = function() {
		app.ports.getString.send("FileSelected");
	};
	*/
	
	/*
	var uploadLink = document.createElement("INPUT"); 
	uploadLink.setAttribute("type", "file");

	var file = uploadLink.files[0];
	

	reader.onLoad = (function(event) {
		var newWord = event.target.result;
		app.ports.getString.send(newWord);
	});
	
	if (document.createEvent) {
        var event = document.createEvent('MouseEvents');
        event.initEvent('click', true, true);
        uploadLink.dispatchEvent(event);
    } else {
        uploadLink.click();
    }
	*/
	
}

function download(filename, text) {
    var downloadLink = document.createElement('a');
    downloadLink.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
    downloadLink.setAttribute('download', filename);
	var event = document.createEvent('MouseEvents');
	event.initEvent('click', true, true);
    downloadLink.dispatchEvent(event);    
}


/*
function upload() {
	var uploadLink = document.createElement("INPUT"); 
	uploadLink.setAttribute("type", "file");
	
	if (document.createEvent) {
        var event = document.createEvent('MouseEvents');
        event.initEvent('click', true, true);
        uploadLink.dispatchEvent(event);
		return openFile(event);
    } else {
        uploadLink.click();
    }
	return "Nada";
}

function openFile(event) {
    var input = event.target;

    var reader = new FileReader();
    reader.onload = function(){
      var text = reader.result;
      console.log(reader.result.substring(0, 200));
    };
    return reader.readAsText(input.files[0]);
  };
*/

/*
function upload() {
	var uploadLink = document.createElement("INPUT"); 
	uploadLink.setAttribute("type", "file");
	
	if (document.createEvent) {
        var event = document.createEvent('MouseEvents');
        event.initEvent('click', true, true);
        uploadLink.dispatchEvent(event);
    } else {
        uploadLink.click();
    }
	
	var files = document.getElementById('input').files;
	var numFiles = files.length;
	return numFiles;
}
*/