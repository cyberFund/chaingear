import * as React from "react";
import {Router, Route, browserHistory} from "react-router";


import App from "./containers/app/";
import HomePage from './containers/home/';
import NewRegister from './containers/new';
import RegisterPage from './containers/register/';
import Test from './containers/test/';


export function Root() {
  return (
    <Router  history={browserHistory}>
      <Route component={App} >
      <Route path={"/"} component={HomePage}/>
      <Route path={"/test"} component={Test}/>
      <Route path={"/new"} component={NewRegister}/>
      <Route path={"/registers/:adress"} component={RegisterPage}/>

      </Route>
    </Router>
  );
}