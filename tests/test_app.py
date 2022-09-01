def test_hello(client):
    response = client.get("/")
    assert b"Hello, World!" in response.data


def test_predict(client):
    year = 2030
    r = client.get("/predict",
        json={
            "Year": year,
        },)
    
    assert r.status_code == 200
    p = r.json['prediction']
    assert p > 0