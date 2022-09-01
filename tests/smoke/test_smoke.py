import requests

from mlops_api import config

def test_home():
    url = config.get_api_url()
    r = requests.get(f"{url}/")
    assert r.status_code == 200

def test_predict():
    url = config.get_api_url()
    year = 2030
    r = requests.get(f"{url}/predict",
        json={
            "Year": year,
        },)
    assert r.status_code == 200
    p = r.json()['prediction']
    assert p > 0