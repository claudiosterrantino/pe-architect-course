package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
)

type URL struct {
	Route string `json:"route"`
	URL   string `json:"url"`
}

func main() {
	router := gin.Default()
	router.Use(allowCORS())

	// Define a GET endpoint
	router.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"redirector": true,
		})
	})

	// Get a URL for a route
	router.GET("/:route", func(c *gin.Context) {
		route := "/" + c.Param("route")
		url := getURL(route)
		if url != "" {
			c.Redirect(http.StatusFound, url)
			return
		}
		c.JSON(http.StatusNotFound, gin.H{"message": "url not found"})
	})

	// Define a GET endpoint
	router.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"urlshortener-redirector (written in Go)": "v1.0.0",
		})
	})

	// Start the server
	router.Run(":8080")
}

func getURL(routeId string) string {
	connStr := "user=shorties password=shorties dbname=urls host=" + os.Getenv("POSTGRES_SERVER") + " sslmode=disable"
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
	// Query for a single row
	query := fmt.Sprintf("SELECT url FROM routes WHERE route = '%s'", routeId)
	fmt.Println(query)
	row := db.QueryRow(query)
	var url string
	err = row.Scan(&url)
	if err != nil {
		if err == sql.ErrNoRows {
			fmt.Println("No rows were returned!")
		} else {
			fmt.Println("Error scanning row:", err)
		}
	}
	return url
}

func allowCORS() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	}
}
