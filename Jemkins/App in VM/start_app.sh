#!/bin/bash

PID_FILE="app.pid"


if [ -f "$PID_FILE" ]; then

    OLD_PID=$(cat "$PID_FILE")

    
    if kill -0 "$OLD_PID" 2>/dev/null; then
        echo "Завершаем старое приложение с PID $OLD_PID..."
        kill "$OLD_PID"   
        sleep 1            
    fi

    
    rm "$PID_FILE"
fi


echo "Запускаем новое приложение..."
nohup python3 app.py & 
NEW_PID=$!


echo "$NEW_PID" > "$PID_FILE"
echo "Приложение запущено с PID $NEW_PID"
