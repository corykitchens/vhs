import React from 'react';
import logo from './logo.svg';
import './App.css';

const URL = 'https://d46o8twy01.execute-api.us-west-2.amazonaws.com/dev/'



class App extends React.Component {
  constructor(props) {
    super();
    this.state = {
      key_name: ''
    }
    this.handleChange = this.handleChange.bind(this);
    this.submitForm = this.submitForm.bind(this);
  }

  handleChange(e) {
    this.setState({key_name: e.target.value});
    console.log(this.state.key_name)
  }

  submitForm(e) {
    e.preventDefault();
    fetch(URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        key_name: this.state.key_name,
      })})
      .then(response => alert(`Creating Server for ${this.state.key_name}`))
      .catch(err => console.log('err'))
  }
  render() {
    return (
      <div className="row">
        <div className="col">
          <div className="box form-box">
            <h1 className="title">VSH Request Form</h1>
            <label className="label">Requester Name</label>
            <input className="input" type="text" placeholder="Input your Keyname" name="KEY_NAME" value={this.state.key_name} onChange={this.handleChange}/>
            <div class="field is-grouped">
              <div class="control">
                <button className="button is-link" onClick={this.submitForm}>Submit</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default App;
