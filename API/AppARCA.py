from flask import Flask, render_template, request, jsonify, redirect, url_for
from Recomendations import Recomendations
from datetime import datetime
import pandas as pd
import json
# import asyncio


app = Flask(__name__)

all_groups_list = []
groups_of_user = []
variavel = 0


@app.route("/")
def index():
    print("Init")
    global all_groups_list
    Recomendations.caculateSimilarity()
    readNewCSV()
    return render_template('index.html')


def readNewCSV():
    print("Read new Data Frame")
    New_DF = pd.read_csv('All_Groups.csv')
    global all_groups_list
    for i in range(0, New_DF['Groups'].max()+1):
        all_groups_list.append(New_DF.loc[New_DF['Groups'] == i])

# ROTAS MOBILE
@app.route('/arca/mobile/login/<user_id>')
def loginMobile(user_id):
    exists = validateLogin(user_id)
    if exists:
        groups = searchGroupsByUser(user_id)
        return jsonify(groups)
    return "False"


@app.route('/arca/mobile/searchGroups/<user_id>')
def groupsByUserMobile(user_id):
    groups = searchGroupsByUser(user_id)
    return jsonify(groups)


# METODOS DE CONSULTA
def validateLogin(user_id):
    users_cars = pd.read_csv('datamcar.csv')

    value = users_cars.loc[users_cars['Moid'] == int(user_id)]
    exists = len(value)

    if exists:
        return True
    else:
        return False


# CONSULTA GRUPOS POR USUÁRIO
def searchGroupsByUser(user):
    groups_of_user = []
    users_cars = pd.read_csv('datamcar.csv')
    global all_groups_list

    all_groups_list = []

    readNewCSV()

    for g in range(0, len(all_groups_list)):
        retorno = all_groups_list[g].loc[all_groups_list[g]['Moid'] == int(user)]
        existe = len(retorno)

        if (existe):
            idGroup = g
            
            all_times = all_groups_list[g]['TstartTimestamp'].loc[all_groups_list[g]['Moid'] == int(user)]
            timeInit = str(datetime.fromtimestamp(all_times.min()))

            users = all_groups_list[g]['Moid'].unique().tolist()

            all_users = []

            for i in range(len(users)):
                user_car = users_cars.loc[users_cars['Moid'] == users[i]]

                moid = str(user_car['Moid'].iloc[0])
                licence_car = str(user_car['Licence'].iloc[0])
                model = str(user_car['Model'].iloc[0])

                car_json = {'Moid': moid, 'Licence': licence_car, 'Model': model}

                all_users.append(car_json)
            

                
                

            data = {'idGroup': idGroup, 'timeInit': timeInit, 'users': all_users}
            # groups_of_user.append(json.dumps(data))
            if len(users) > 1:
                groups_of_user.append(data)

    return groups_of_user


if __name__ == "__main__":
    # app.run(host='192.168.0.103', port=9011, debug=True)
    # app.run(host='10.20.30.95', port=9011, debug=True)
    app.run(host='192.168.1.18', port=9011, debug=True)