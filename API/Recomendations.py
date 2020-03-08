import numpy as np
import pandas as pd
import matplotlib.pyplot as pl
import csv
import time
from sklearn.cluster import OPTICS
from sklearn.cluster import DBSCAN
from sklearn.metrics import davies_bouldin_score
from sklearn import metrics


class Recomendations():
  
  @staticmethod
  def caculateSimilarity():
    all_groups = []
    print("Calculando rotas...")

    # READ TO CSV FILE
    print("Lendo o Data Frame...")
    data_frame = pd.read_csv('TripsNormalizadaId.csv')
    db = data_frame
    db = db.iloc[0:60000]


    #CAPTURA O HORARIO DE SAÍDA DE CADA VIAGEM
    list_time = []
    for i in range (0, db['Tripid'].max()+1):
      exist = db['Tripid'].loc[db['Tripid'] == i].sum()
      if(exist):
        list_time.append(db.loc[db['Tripid'] == i].head(1))
    trips_start = pd.concat(list_time)
    time_test = trips_start.iloc[:,9:10]   


    # READ COLUMN TIME START
    time_start = time_test
    

    # CLUSTERING OPTICS PER TIME START
    print("Agrupamento por tempo...")
    clustering = OPTICS(max_eps=300,min_samples=2).fit(time_start)
    labels = clustering.labels_
    trips_start['GroupsTstart'] = clustering.labels_
    
    array_tripId = db['Tripid'].values

    lista_groups = []

    for i in range(0, db['Id'].max()+1):
      value = array_tripId[i]
      number_group = trips_start['GroupsTstart'].loc[trips_start['Tripid'] == value].max()
      lista_groups.append(number_group)

    db['GroupsTstart'] = np.asarray(lista_groups)
    
    # CLUSTERING OPTICS PER ROUTES AND GENERATE FINAL GROUPS
    # -----------------------------------------------------------------------------------------------
    
    groups_per_time = []

    print("Agrupamento por rota...")
    for i in range(0,db['GroupsTstart'].max()+1):
      groups_per_time.append(db.loc[db['GroupsTstart'] == i])
      routes = groups_per_time[i].iloc[:,5:7]
      
      clustering_routes = DBSCAN(eps=0.0024, min_samples=2).fit(routes)
      labels = clustering_routes.labels_
      groups_per_time[i]['GroupsRoutes'] = clustering_routes.labels_

      for gp in range(0, clustering_routes.labels_.max()+1):
        all_groups.append(groups_per_time[i].loc[groups_per_time[i]['GroupsRoutes'] == gp])


    print("Done")
    #CONCATENA TODA A LISTA DE GRUPOS E SALVA EM UM NOVO CSV
    for g in range(0, len(all_groups)):
      all_groups[g]['Groups'] = g

    New_DF = pd.concat(all_groups)

    New_DF.to_csv('All_Groups.csv', index=False) 
    print("Saving new DataFrame")
    
    
    # -----------------------------------------------------------------------------------------------
    # all_groups is the list that contains all groups per time of start and routs similar
