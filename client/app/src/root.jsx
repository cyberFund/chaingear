import * as React from 'react';
import { Router, Route } from 'react-router';
import { createHashHistory } from 'history'; // use hash becouse ipfs  use path /ipfs/hash/{app}
import { MainContainer, ScrollContainer } from '@cybercongress/ui';
import HomePage from './containers/home';
import NewDatabase from './containers/new/DatabaseInitialization';
import DatabasePage from './containers/database';
import App from './containers/App/App';
import SchemaDefinition from './containers/new/SchemaDefinition';

export const history = createHashHistory({});

export function Root() {
    return (
        <Router history={ history }>
            <Route component={ App }>
            {/* <Route component={ ScrollContainer }> */}
            {/*
                <Route component={ MainContainer }> */}
            <Route path='/' component={ HomePage } />
            <Route path='/new' component={ NewDatabase } />
            <Route path='/schema/:dbsymbol' component={ SchemaDefinition } />
            {/* </Route> */}
            <Route path='/databases/:dbsymbol' component={ DatabasePage } />
            {/* </Route> */}
            </Route>
        </Router>
    );
}
