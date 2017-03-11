# ML API

## Roadmap
* [x] Limit requests access per ip address
* [x] Limit requests access per token
* [x] Filter by query
* [ ] Allow customer post a image url and return the result of predictions
* [ ] Filter by customer's image

## Architecture Diagram
![Machine Learning Service Application Architecture](https://c7.staticflickr.com/6/5467/30326223422_fb15e3c2c8_b.jpg)

## Requirements
- Ubuntu 14.04 or Ubuntu 16.04
- Rails 5+
- Ruby 2.2+

## Install DeepDetect
**Install dependencies:**
```
sudo apt-get install build-essential libgoogle-glog-dev libgflags-dev libeigen3-dev libopencv-dev libcppnetlib-dev libboost-dev libboost-iostreams-dev libcurlpp-dev libcurl4-openssl-dev protobuf-compiler libopenblas-dev libhdf5-dev libprotobuf-dev libleveldb-dev libsnappy-dev liblmdb-dev libutfcpp-dev cmake libgoogle-perftools-dev unzip
```

**Clone & build deepdetect:**
```
cd && mkdir Projects && git clone git@github.com:beniz/deepdetect.git
cd deepdetect && mkdir build
cd build
cmake ..
make
```

**Start the server:**
```
cd build/main
./dede

DeepDetect [ commit 73d4e638498d51254862572fe577a21ab8de2ef1 ]
Running DeepDetect HTTP server on localhost:8080
```

Read more at https://github.com/beniz/deepdetect

## How to run
```
git clone git@github.com:ntamvl/deepdetect-client-rails-example.git
bundle install

# edit config/database.yml then run
rails db:create && rails db:migrate && rails db:seed

# run on development
rails s -b 0.0.0.0

# run on production as daemonize
bundler exec puma -C config/puma.rb -e production -d
```

## Usage
**Filter by simple query***
- Endpoint: `POST /v1/filter`
- Params: JSON formatted body
- Structure of params:
```
{
  "query": {
    "hashtags": <array of string (optional)>
    "and": <array of model's category, default: ["no_selfie"]>,
    "or": <array of model's category, default: []>,
    "not": <array of model's category, default: []>
  },
  "pagination": {
    "from": <integer (default: 0)>,
    "size": <integer (default: 10)>
  }
}
```
- Params example:
```
{
  "query": {
    "and": ["someone", "no_selfie"],
    "or": ["men", "women"],
    "not": []
  },
  "pagination": {
    "from": 0,
    "size": 10
  }
}
```

**Auto filter for ASOS with hashtag asos or asseeonme**
- Endpoint: `POST /v1/filter_auto_asos`
- Header:
  - Authorization: Authentication token
- Params:
  - from: integer, default: 0, pagination with offset
  - size: integer, default: 20, pagination with limit

**Predict an image by model**
- Endpoint: `POST /v1/predict`
- Header:
  - Authorization: Authentication token
- Params:
  - image_url: string, required
  - model: string, required

## How to demo
```
curl -H "Authorization: Token token=XpDtuHtCQfgQf4RZnf85Nwtt" -H "Content-Type: application/json" http://localhost:3000/v1/filter -d '
{
  "query": {
    "hashtags": ["asos", "hype"],
    "and": ["someone", "no_selfie"],
    "or": ["men", "women"],
    "not": ["selfie"]
  },
  "pagination": {
    "from": 0,
    "size": 20
  }
}'
```
or on staging
```
curl -H "Authorization: Token token=TtDKqIuz50GyNpl7z8tMtQtt" -H "Content-Type: application/json" http://staging.feels.com:8081/v1/filter -d '
{
  "query": {
    "hashtags": ["asos", "hype"],
    "and": ["someone", "no_selfie"],
    "or": ["men", "women"],
    "not": ["selfie"]
  },
  "pagination": {
    "from": 0,
    "size": 20
  }
}'
```

## How to use API docs
**Create a new user:**
```
u = User.create(name: "Tam Nguyen", email: "ntamvl@gmail.com", password: "123456", password_confirmation: "123456")
u.update_columns(api_key: "TtDKqIuz50GyNpl7z8tMtQtt")
```

**Access `http://localhost:3000/docs`**

**Example with endpoint `POST /v1/filter.json`:**
*Use token*
```
Token token=TtDKqIuz50GyNpl7z8tMtQtt
```
*With json body*
```
{"query": {"and": ["someone", "no_selfie"], "or": ["men", "women"], "not": ["selfie"] }, "pagination": {"from": 0, "size": 20 } }
```

## Contributing
ML API is designed and implemented by Tam Nguyen [ntamvl@gmail.com](ntamvl@gmail.com)
Bug reports and pull requests are welcome on GitHub at https://github.com/ntamvl/deepdetect-client-rails-example

## License
MIT
