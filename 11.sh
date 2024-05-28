#!/bin/bash

# Navigate to the backend directory and start the backend server
echo "Starting backend server..."
cd lab2/backend
node index.js &
backend_pid=$!

# Navigate to the frontend directory and start the frontend server
echo "Starting frontend server..."
cd ../frontend
npm run serve &
frontend_pid=$!

# Wait for both servers to finish
wait $backend_pid
wait $frontend_pid