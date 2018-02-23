import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

var node = document.getElementById('root');
var app = Main.embed(node);
registerServiceWorker();