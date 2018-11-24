port module Ports exposing (firebaseLoginRequest, firebaseAuthStateRequest, firebaseLogoutRequest, firebaseLoginSuccess, firebaseLoginFault, firebaseLogoutSuccess, firebaseLogoutFault)


-- Out ports
port firebaseLoginRequest : Cmd msg
port firebaseAuthStateRequest : Cmd msg
port firebaseLogoutRequest : Cmd msg

-- In ports
port firebaseLoginSuccess : (String -> msg) -> Sub msg
port firebaseLoginFault : (String -> msg) -> Sub msg
port firebaseLogoutSuccess : msg -> Sub msg
port firebaseLogoutFault : (String -> msg) -> Sub msg