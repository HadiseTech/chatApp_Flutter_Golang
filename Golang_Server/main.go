package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strings"
	// "time"

	// "github.com/gorilla/websocket"
	"github.com/gorilla/websocket"
	gubrak "github.com/novalagung/gubrak/v2"
)

type M map[string]interface{}

const MESSAGE_NEW_USER = "New User"
const MESSAGE_CHAT = "Chat"
const MESSAGE_LEAVE = "Leave"
const MESSAGE_USERNAME_SIMILAR = "Username Existed"
const MESSAGE_END = "end"

var connections = make([]*WebSocketConnection, 0)

var stat int = 0

type SocketPayload struct {
	Message string
}

type SocketResponse struct {
	From    string
	Type    string
	Message string
}

type WebSocketConnection struct {
	*websocket.Conn
	Username string
}

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// fmt.Print("Server is serving index.html file")
		content, err := ioutil.ReadFile("index.html")
		if err != nil {
			http.Error(w, "Could not open requested file", http.StatusInternalServerError)
			return
		}

		fmt.Fprintf(w, "%s", content)
	})

	http.HandleFunc("/ws", func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("CLient is trying to conenct")
		currentGorillaConn, err := websocket.Upgrade(w, r, w.Header(), 1024, 1024)
		if err != nil {
			http.Error(w, "Could not open websocket connection", http.StatusBadRequest)
		}

		username := r.URL.Query().Get("username")
		var testUsername int
		testUsername = 0
		for _, eachConn := range connections {
			if username == eachConn.Username {
				testUsername += 1

			}

		}

		if testUsername > 0 {
			fmt.Println("The user names are similar")
			handleUsername(currentGorillaConn, MESSAGE_USERNAME_SIMILAR, "")
		} else {
			currentConn := WebSocketConnection{Conn: currentGorillaConn, Username: username}
			connections = append(connections, &currentConn)
			go handleIO(&currentConn, connections)
		}

	})

	fmt.Println("Server starting at :8080")
	http.ListenAndServe("192.168.137.1:8080", nil)
}

func handleUsername(currentConn *websocket.Conn, kind, message string) {

	currentConn.WriteJSON(SocketResponse{

		Type:    kind,
		Message: message,
	})

}

func handleIO(currentConn *WebSocketConnection, connections []*WebSocketConnection) {
	fmt.Println("handleIo function is being called")
	defer func() {
		if r := recover(); r != nil {
			log.Println("ERROR", fmt.Sprintf("%v", r))
		}
	}()

	broadcastMessage(currentConn, MESSAGE_NEW_USER, "")

	for {
		payload := SocketPayload{}
		err := currentConn.ReadJSON(&payload)
		if err != nil {
			if strings.Contains(err.Error(), "websocket: close") {
				broadcastMessage(currentConn, MESSAGE_LEAVE, "")
				ejectConnection(currentConn)
				return
			}

			log.Println("ERROR", err.Error())
			continue
		}

		
		
		
		broadcastMessage(currentConn, MESSAGE_CHAT, payload.Message)
		// time.Sleep(50 * time.Millisecond)
		// broadcastMessage(currentConn, MESSAGE_END, "")
		
	}
}

func ejectConnection(currentConn *WebSocketConnection) {
	fmt.Println("eject function is being called")
	filtered := gubrak.From(connections).Reject(func(each *WebSocketConnection) bool {
		return each == currentConn
	}).Result()
	connections = filtered.([]*WebSocketConnection)
}

func broadcastMessage(currentConn *WebSocketConnection, kind, message string, ) {
	fmt.Println("broadcast funciton is beinge called")
	// for _, eachConn := range connections {
	// 	if eachConn == currentConn {
	// 		continue
	// 	}

	// 	eachConn.WriteJSON(SocketResponse{
	// 		From:    currentConn.Username,
	// 		Type:    MESSAGE_END,
	// 		Message: ""})

	// }

	for _, eachConn := range connections {
		if eachConn == currentConn {
			continue
		}

		eachConn.WriteJSON(SocketResponse{
			From:    currentConn.Username,
			Type:    kind,
			Message: message})

	}
	
	
	

	// broadcastMessage(currentConn, MESSAGE_END, "")
}
