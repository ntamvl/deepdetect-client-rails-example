# DeepDetect Client Rails Example

## Requirements
- Ubuntu 14.04 or Ubuntu 16.04
- Rails 5+
- Ruby 2.2+
- Redis

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

**Clone models that are trained by me:**
```
cd && mkdir Models
wget http://ntam.me/downloads/person_yes_no.tar.gz
tar xvf person_yes_no.tar.gz
```

Type cmd `pwd` at folder Models to get absolute path

Example with my absolute path model
```
/home/tamnguyen/Models
```

## How to run
```
git clone git@github.com:ntamvl/deepdetect-client-rails-example.git
bundle install

# edit config/database.yml then run
rails db:create && rails db:migrate && rails db:seed

# edit deepdetect config at config/deepdetect.json
# update model_path like this
{
  "model_path": "/home/tamnguyen/Models"
}

# run on development
rails s -b 0.0.0.0

# run on production as daemonize
bundler exec puma -C config/puma.rb -e production -d
```

## Usage
**Predict an image by model**
- Endpoint: `POST /v1/predict`
- Header:
  - Authorization: Authentication token
- Params:
  - image_url: string, required
  - model: string, required

## How to use
```
curl -X POST --header 'Content-Type: application/x-www-form-urlencoded' --header 'Accept: application/json' --header 'Authorization: Token token=TtDKqIuz50GyNpl7z8tMtQtt' -d 'image_url=https%3A%2F%2Fscontent.fsgn1-1.fna.fbcdn.net%2Fv%2Ft1.0-9%2F1239414_10201956642662189_587041755_n.jpg%3Foh%3D9e9be2c2b9318abac66abde163a88399%26oe%3D592CF192&model=person_yes_no' 'http://127.0.0.1:3000/v1/predict.json'
```

OR use API docs at `http://localhost:3000/docs`

![Example result](https://raw.githubusercontent.com/ntamvl/deepdetect-client-rails-example/master/example_result.png)


## Architecture Diagram
![Machine Learning Service Application Architecture](https://c7.staticflickr.com/6/5467/30326223422_fb15e3c2c8_b.jpg)

## Contributing
ML API is designed and implemented by Tam Nguyen [ntamvl@gmail.com](ntamvl@gmail.com)
Bug reports and pull requests are welcome on GitHub at https://github.com/ntamvl/deepdetect-client-rails-example

> I will upload more models when I have free time :D :P

> you can get more models at http://ntam.me/downloads/

## License
MIT
