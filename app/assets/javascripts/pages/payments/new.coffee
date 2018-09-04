@on 'turbolinks:load', 'payments-new', ->
  initialize_form = ->
    stripe = window.Stripe(stripe_publishable_key)
    elements = stripe.elements()

    style = {
      base: {
        # Add your base input styles here. For example:
        fontSize: '16px',
        color: "#32325d",
      }
    }


    #Create an instance of the card Element.
    card = elements.create('card', {style: style})

    # Add an instance of the card Element into the `card-element` <div>.
    card.mount('#card-element')

    card.addEventListener 'change', (event) =>
      displayError = document.getElementById 'card-errors'
      if event.error
        displayError.textContent = event.error.message
      else
        displayError.textContent = ''

    stripeTokenHandler = (token) ->
      # Insert the token ID into the form so it gets submitted to the server
      form = document.getElementById 'new_payment'
      hiddenInput = document.createElement 'input'
      hiddenInput.setAttribute 'type', 'hidden'
      hiddenInput.setAttribute 'name', 'payment[stripe_token]'
      hiddenInput.setAttribute 'value', token.id
      form.appendChild hiddenInput

      # Submit the form
      form.submit()

    form = document.getElementById 'new_payment'
    form.addEventListener 'submit', (event) =>
      event.preventDefault()

      stripe.createToken(card).then (result) =>
        if result.error
          # Inform the customer that there was an error.
          errorElement = document.getElementById('card-errors')
          errorElement.textContent = result.error.message
        else
          # Send the token to your server.
          stripeTokenHandler(result.token)

  wait_for_stripe = ->
    if !window.Stripe
      setTimeout 500, wait_for_stripe
      return
    initialize_form()

  wait_for_stripe()
