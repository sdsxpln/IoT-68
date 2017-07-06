import React, { Component } from 'react';
import 'react-image-gallery/styles/css/image-gallery.css';
import './App.css';
import Tab from 'react-toolbox/lib/tabs/Tab';
import Tabs from 'react-toolbox/lib/tabs/Tabs';
import ImageGallery from 'react-image-gallery';
import Input from 'react-toolbox/lib/input';
import Button from 'react-toolbox/lib/button/Button';
import { Line } from 'react-chartjs-2';
import Dropdown from 'react-toolbox/lib/dropdown';
import axios from 'axios';

const MAIN_URL = 'https://6e11259c.ngrok.io';

function hashCode(str) { // java String#hashCode
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
        hash = str.charCodeAt(i) + ((hash << 5) - hash);
    }
    return hash;
}

function intToRGB(i){
    let c = (i & 0x00FFFFFF)
        .toString(16)
        .toUpperCase();

    return "00000".substring(0, 6 - c.length) + c;
}

const grandezas = [
    { value: '1', label: 'Umidade' },
    { value: '2', label: 'Temperatura'},
    { value: '3', label: 'Pressao' },
    { value: '8', label: 'Imagem'},
    { value: '11', label: 'Girometro'},
    { value: '12', label: 'Acelerometro'},
    { value: '13', label: 'Luminosidade'},
    { value: '14', label: 'Campo Eletromagnetico'},
    { value: '16', label: 'CO'},
    { value: '26', label: 'Carga da Bateria'},
    { value: '28', label: 'Tensao'},
    { value: '29', label: 'Corrente'}
];

class Gallery extends Component {

  render() {
      const images = this.props.images ?

          this.props.images.map((imageInfo) => {
              return (
                  {
                      original: imageInfo.url,
                      thumbnail: imageInfo.url,
                      description: imageInfo.description
              });
          }) : [];

      return (
          <ImageGallery
              items={images}
              slideInterval={2000}
              onImageLoad={this.handleImageLoad}/>
      );
  }
}

class App extends Component {

  constructor() {
    super();

    this.state  = {
        index: 1,
        dropDownValue: grandezas[0].value,
        history: {},
        images: [],
        now: null
    };
  }

  componentDidMount() {
      axios.get(`${MAIN_URL}/morelit/history`).then((response) => {

          let { history } = this.state;

          console.log(response);

          response.data.data.forEach((data) => {

              const { grandeza } = data;
              const valor = data.valor.trim();
              const no = data.no.trim();
              const date = data.data;
              const info = grandezas.find((grandeza) => {
                  return grandeza.value === data.grandeza;
              });

              if (!(no in history)) {
                  history[no] = {};
              }

              if (!(grandeza in history[no])) {
                  history[no][grandeza] = {label: info.label, infos: []};
              }

              history[no][grandeza].infos.push({value: valor, date: new Date(date)});
          });

          this.setState({
              history: history
          });
      });

      axios.get(`${MAIN_URL}/morelit/images?endereco=`).then((response) => {

          let { images } = this.state;

          console.log(response);

          response.data.data.sort(function(a,b) {
              a = a.data.split('/').reverse().join('');
              b = b.data.split('/').reverse().join('');
              return a > b ? 1 : a < b ? -1 : 0;
          });

          response.data.data.forEach((data) => {
              const { valor, no } = data;
              const date = data.data;
              images.push({url: `${MAIN_URL}${valor}`, description: `${no} - ${date}`});
          });

          this.setState({
              images: images
          });
      })
  }

  handleChange = (value) => {
      this.setState({dropDownValue: value});
  };

  handleTabChange = (index) => {
      this.setState({index});
  };

  getNowInfo = () => {

      const endereco = document.querySelector('#end').value;

      axios.get(`${MAIN_URL}/morelit/now?endereco=${endereco}&grandeza=${this.state.dropDownValue}`).then((response) => {
          console.log(response);
          alert(JSON.stringify(response.data, null, 2));
      })
  };

  render() {
    return (
      <div className='App'>
        <Tabs index={this.state.index} onChange={this.handleTabChange}>
          <Tab label='Now'>
              <section>
                  <Input type='text' label='Endereço' id='end'/>
                  <Dropdown
                      auto
                      onChange={this.handleChange}
                      source={grandezas}
                      value={this.state.dropDownValue}
                  />
                  <Button type='submit'
                          label={'enviar'}
                          raised
                          onClick={this.getNowInfo.bind(this)}
                  />
                  {
                      this.state.now ?
                          <div style={{marginTop: '15px'}}>
                              <pre>{this.state.now}</pre>
                          </div> : null
                  }
              </section>
          </Tab>
          <Tab label='History'>
              {
                  Object.keys(this.state.history).map((nodeKey) => {

                      return (

                          Object.keys(this.state.history[nodeKey]).map((key) => {

                              if (key === '14' || key === '12' || key === '11') {
                                  return null;
                              }

                              return (

                                  <Line data={{
                                      labels: this.state.history[nodeKey][key].infos.map((info) => {
                                          return `${info.date.getHours()}:${info.date.getMinutes()}`;
                                      }),
                                      datasets: [
                                          {
                                              label: `${this.state.history[nodeKey][key].label} - ${nodeKey}`,
                                              fill: false,
                                              lineTension: 0.1,
                                              backgroundColor: `#${intToRGB(hashCode(nodeKey))}`,
                                              borderColor: `#${intToRGB(hashCode(nodeKey))}`,
                                              borderCapStyle: 'butt',
                                              borderDash: [],
                                              borderDashOffset: 0.0,
                                              borderJoinStyle: 'miter',
                                              pointBorderColor: `#${intToRGB(hashCode(nodeKey))}`,
                                              pointBackgroundColor: '#fff',
                                              pointBorderWidth: 1,
                                              pointHoverRadius: 5,
                                              pointHoverBackgroundColor: `#${intToRGB(hashCode(nodeKey))}`,
                                              pointHoverBorderColor: `#${intToRGB(hashCode(nodeKey))}`,
                                              pointHoverBorderWidth: 2,
                                              pointRadius: 1,
                                              pointHitRadius: 10,
                                              data: this.state.history[nodeKey][key].infos.map((info) => {
                                                  return info.value;
                                              }),
                                          }
                                      ]
                                  }}
                                  />
                              );
                        })
                      );
                  })
              }
          </Tab>
          <Tab label='Gallery'>
              <Gallery images={this.state.images}/>
          </Tab>
        </Tabs>
      </div>
    );
  }
}

export default App;
