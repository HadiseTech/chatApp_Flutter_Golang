package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	// "github.com/gorilla/websocket"
)

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

	http.ListenAndServe("localhost:9090/", nil)
}
