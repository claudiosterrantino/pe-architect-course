# Start from the official Go image
FROM golang:1.18-alpine

# Set the working directory
WORKDIR /app

# Copy the source code
COPY . .

ENV POSTGRES_DB=$POSTGRES_DB

# Build the Go app
RUN go build -o redirector .

# Run the Go app
CMD ["./redirector"]

# Expose the port that the app listens on
EXPOSE 8080
