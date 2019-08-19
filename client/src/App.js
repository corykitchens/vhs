import React from 'react';
import logo from './logo.svg';
import './App.css';

const URL = 'https://d46o8twy01.execute-api.us-west-2.amazonaws.com/dev/'




function App() {
  function submitForm(e) {
    e.preventDefault();
    fetch(URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        key_name: "HelloWorld",
      })})
      .then(response => alert('Success!'))
      .catch(err => console.log('err'))
  }

  return (
    <div className="row">
      <div className="col">
        <div className="box form-box">
          <label className="label">Requester Name</label>
          <input className="input" type="text" placeholder="myusername" name="KEY_NAME" />
          <button className="button is-link" onClick={submitForm}>Submit</button>
        </div>
      </div>
    </div>
  );
}

export default App;
