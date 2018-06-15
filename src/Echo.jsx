import React from 'react';
import axios from 'axios';

export default class EchoComponent extends React.Component {
  constructor() {
    super();

    this.state = { data: '' };
  }

  componentDidMount() {
    axios.get('http://localhost/echo/get?foo1=bar1&foo2=bar2')
         .then((res) => {
           console.log(res.data);
           this.setState({ data: res.data });
         });
  }

  render() {
    return (
      <pre>{ JSON.stringify(this.state.data) }</pre>
    );
  }
}
