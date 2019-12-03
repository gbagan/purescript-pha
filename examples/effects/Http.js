exports.ajaxAux = just => nothing => url => action => () => 
    fetch(url, {})
      .then(response => {
        if (!response.ok) {
          throw response
        }
        return response
      })
      .then(body => body.json())
      .then(result => action(just(result))())
      .catch(error => action(nothing)())