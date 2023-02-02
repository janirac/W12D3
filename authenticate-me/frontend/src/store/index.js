import { createStore, applyMiddleware, compose } from 'redux'
import thunk from 'redux-thunk'

const rootReducer = (combineReducers) => {

}

let enhancer;

if (process.env.NODE_ENV === 'production') {
    enhancer = applyMiddleware(thunk)
} else {
    const logger = require('redux-logger').default
    const composeEnhancers = 
        window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose
    enhancer = composeEnhancers(applyMiddleware(thunk, logger))
}
//why don't I need to set preloadedstate to an empty object if its optional
const configureStore = (preloadedState = {}) => {
    return createStore(rootReducer, preloadedState, enhancer)
}

export default configureStore;