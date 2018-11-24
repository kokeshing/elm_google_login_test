import './main.css';
import { Elm } from './Main.elm';
import firebase from 'firebase'
import registerServiceWorker from './registerServiceWorker';

const app = Elm.Main.init({
  node: document.getElementById('root')
});

// Initialize Firebase
const config = {
    apiKey: "YOUR API KEY",
    authDomain: "YOUR DOMAIN",
    databaseURL: "YOUR DATABASE",
    projectId: "YOUR PROJECT ID",
    storageBucket: "",
    messagingSenderId: "YOUR SENDER ID"
};
firebase.initializeApp(config);

const provider = new firebase.auth.GoogleAuthProvider();

app.ports.firebaseLoginRequest.subscribe(function(_) {
    firebase.auth().signInWithRedirect(provider);
});

app.ports.firebaseAuthStateRequest.subscribe(function(_) {

    firebase.auth().getRedirectResult().then(function(result) {

        if (result.user){
            console.log(result.user);
            app.ports.firebaseLogined.send(result.user.email);
        }else if (firebase.auth().currentUser) {
            app.ports.firebaseLogined.send(firebase.auth().currentUser.email);
        }else{
            app.ports.firebaseNotLogined.send("Not Logined");
        }

    }).catch(function(error) {
        app.ports.firebaseLoginError.send(error.message);
    });

});

app.ports.firebaseLogoutRequest.subscribe(function(_) {

    firebase.auth().signOut().then(function() {
        app.ports.firebaseLogoutSuccess.send("Logout Success");
    }).catch(function(error) {
        app.ports.firebaseLogoutFault.send(error);
    });

});

registerServiceWorker();
