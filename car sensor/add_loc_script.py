import os
from geopy.geocoders import Nominatim
import pandas as pd

def get_locs(file,file_to_store):
    #df = pd.read_csv('20170223_Kevin2Work.csv',header=1)
    all_locs = []
    df = pd.read_csv(file,header=1)
    for lat,long in zip(df[' Latitude (deg)'],df[' Longitude (deg)']):
        geolocator = Nominatim()
        location = geolocator.reverse((lat,long),timeout=10)
        all_locs.append(location.address)
    street_type = get_street_type(all_locs)
    df['address'] = all_locs
    df['street_type'] = street_type
    df.to_csv(file_to_store,header=1)
    return df

def get_street_type(all_locs):
    highways = ['I-75','I-20','I-24','I-59','I-75','I-85','I-95']
    street_type = []
    for loc in all_locs :  
        for highway in highways:
            if highway in loc :
                street_type.append('highway')
                break
        street_type.append('street')
    return street_type

categories = ['Kevin']

for category in categories:
    folder = '/Users/Madhu/Documents/Courses/RA/car sensor/'+category
    file_names  = os.listdir(folder)
    for file_name in file_names:
        file = os.path.join(folder, file_name)
        print ("Reading file ",file)
        folder_to_store = '/Users/Madhu/Documents/Courses/RA/car sensor/'+category+'_loc'
        file_to_store = os.path.join(folder_to_store, file_name)
        get_locs(file,file_to_store)
        print ("Writing file ",file_to_store)
