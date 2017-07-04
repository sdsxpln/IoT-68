import React, { Component } from 'react';
import 'react-image-gallery/styles/css/image-gallery.css';
import './App.css';
import Tab from 'react-toolbox/lib/tabs/Tab';
import Tabs from 'react-toolbox/lib/tabs/Tabs';
import ImageGallery from 'react-image-gallery';

class Gallery extends Component {
  render() {
      const images = [
          {
              original: 'http://lorempixel.com/1000/600/nature/1/',
              thumbnail: 'http://lorempixel.com/250/150/nature/1/',
          },
          {
              original: 'http://lorempixel.com/1000/600/nature/2/',
              thumbnail: 'http://lorempixel.com/250/150/nature/2/'
          },
          {
              original: 'http://lorempixel.com/1000/600/nature/3/',
              thumbnail: 'http://lorempixel.com/250/150/nature/3/'
          }
      ];

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
    };
  }

  handleTabChange = (index) => {
      this.setState({index});
  };

  handleActive = () => {
      console.log('Special one activated');
  };

  render() {
    return (
      <div className='App'>
        <Tabs index={this.state.index} onChange={this.handleTabChange}>
          <Tab label='Primary'><small>Primary content</small></Tab>
          <Tab label='Secondary' onActive={this.handleActive}><small>Secondary content</small></Tab>
          <Tab label='Third' disabled><small>Disabled content</small></Tab>
          <Tab label='Fourth' hidden><small>Fourth content hidden</small></Tab>
          <Tab label='Fifth'><small>Fifth content</small></Tab>
        </Tabs>
      </div>
    );
  }
}

export default App;
