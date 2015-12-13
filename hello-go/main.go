package main

import (
  "io"
  "net/http"
  "log"
  "os"
)

// hello world, the web server
func HelloServer(w http.ResponseWriter, req *http.Request) {
  msg := os.Getenv("MSG")
  if msg == "" {
    msg = "hello world!\n"
  }
  io.WriteString(w, msg)
}

func main() {
  log.Print("starting on 12345")
  http.HandleFunc("/", HelloServer)
  err := http.ListenAndServe(":12345", nil)

  if err != nil {
    log.Fatal("ListenAndServe: ", err)
  }
}