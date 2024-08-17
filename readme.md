# OSM Tile Server

Before running the tile server, you need to import the data. You can do this via the setup script.
```bash
./setup_tile_server.sh
```


Use Docker Compose to start the server: 
```bash
docker-compose up -d
```

Access the tile server:

Visit http://your.server.ip.address:8080/tile/0/0/0.png to verify the setup.
Visit http://your.server.ip.address:8080 to view the interactive map.
