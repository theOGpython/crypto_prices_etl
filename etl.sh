#!/usr/bin/sh

#Extract phase
echo "Extracting Data"
# Extract the columns 1 (symbol), 2 (price) from
# (The api source)- coinstats
curl -s --location --request GET https://api.coinstats.app/public/v1/coins/bitcoin\?currency\=USD |\
    grep -oE "\"symbol\""|\
    tr -d '" ' >> symbol.txt

curl -s --location --request GET https://api.coinstats.app/public/v1/coins/ |\
    grep -oE "\"symbol\":\s*\"[A-Z]*\"" |\
    grep -oE "\"[A-Z]*\"" |\
    tr -d '" ' >> symbol.txt
    
curl -s --location --request GET https://api.coinstats.app/public/v1/coins/bitcoin\?currency\=USD |\
    grep -oE "\"price\""|\
    tr -d '" ' >> price.txt

curl -s --location --request GET https://api.coinstats.app/public/v1/coins/ |\
    grep -oE "\"price\":\s*[0-9]*?\.[0-9]*" |\
    grep -oE "[0-9]*?\.[0-9]*" >> price.txt

#Transform phase
echo "Tranforming Data"
# read the extracted data, merge both files together and replace the colons with commas.
paste -d "," symbol.txt price.txt >> cryptoprice.csv

# pre-Loading phase
#echo "Getting the database ready"
#connecting to Postgres CLI (command line)
#psql --username=postgres --host=localhost

# #Creating a Database cyrptoprice
#CREATE DATABASE cryptoprices;
 #connecting to database cryptoprice
#\c cryptoprices;

#Creating table prices 
#create table prices(symbol varchar(7),price varchar(23));
#To Check if table (prices) was created
#\dt

# Load phase
echo "Loading data"

echo "\c cryptoprices;\COPY prices FROM 'cryptoprice.csv' DELIMITERS ',' CSV HEADER;" | psql --username=postgres --host=localhost