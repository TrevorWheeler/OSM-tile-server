# Data Import Step:

Before running the tile server, you need to import the data. Use the following steps:

Download the australia-latest.osm.pbf file from Geofabrik's download server and place it in the same directory as your docker-compose.yml file.

```bash
wget https://download.geofabrik.de/australia-oceania/australia-latest.osm.pbf
```

Import the Data. This will import the australia-latest.osm.pbf file into the PostgreSQL database.
Run the import process using the following command:

```bash
docker-compose run osm-tile-server import
```

```bash
docker-compose up -d
```
