con#!/usr/bin/env /opt/conda/bin/python
import os
from urllib.parse import urlparse
from urllib.parse import parse_qs
from polly.omixatlas import OmixAtlas
from polly.auth import Polly
import sys
print(sys.version_info[0])
print(sys.path)


URL_APP = os.getenv('OPEN_APP_ID')
url_parse = urlparse(URL_APP)
REFRESH_TOKEN = os.getenv("POLLY_REFRESH_TOKEN")

if os.getenv("POLLY_PYTHON_ENV"):
    Polly.auth(REFRESH_TOKEN, env=os.getenv("POLLY_PYTHON_ENV"))
else:
    Polly.auth(REFRESH_TOKEN)
    
print(os.getenv("POLLY_PYTHON_ENV"))

#### get access token and initiate a client 
# library_client =  OmixAtlas(os.environ['POLLY_REFRESH_TOKEN'])
library_client = OmixAtlas()

def downloadDataset(repo_id, dataset_id, file_name = "file.h5ad", library_client = library_client):
    try:
        api_response = library_client.download_data(repo_id, dataset_id).get('data')
        url = api_response["attributes"]["download_url"]
        os.system(f"wget -O '{file_name}' '{url}'")
        print("Dataset download success")
    except Exception as e:
        print("Ooopss, Error " + str(e))
        print("Error occured in downloading dataset from Omix-Atlas")


if(os.getenv('OPEN_APP_ID')==None):
    print("No App ID found using sample data")
    os.system('cp /test-files/file.h5ad /file.h5ad') 
else:
    downloadDataset(repo_id = parse_qs(url_parse.query)['repo_id'][0], 
                dataset_id = parse_qs(url_parse.query)['dataset_id'][0])


