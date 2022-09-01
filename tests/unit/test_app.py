def test_home(client):
    response = client.get("/")
    assert response.status_code == 200


def test_predict(client):
    year = 2030
    r = client.get("/predict",
        json={
            "Year": year,
        },)
    
    assert r.status_code == 200
    p = r.json['prediction']
    assert p > 0