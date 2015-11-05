# app/assets/javascripts/components/records.js.coffee

@Records = React.createClass
	getInitialState: ->
		records: @props.data
	getDefaultProps: ->
		records: []
	addRecord: (record) ->
		records = React.addons.update(@state.records, { $push: [record]})
		@setState records: records
	credits: ->
		credits = @state.records.filter (record) -> record.amount >= 0
		credits.reduce ((prev, curr) ->
			prev + parseFloat(curr.amount)
		), 0
	debits: ->
		debits = @state.records.filter (record) -> record.amount < 0
		debits.reduce ((prev, curr) ->
			prev + parseFloat(curr.amount)
		), 0
	balance: ->
		@debits() + @credits()
	deleteRecord: (record) ->
		records = React.addons.update(@state.records, { $splice: [[index, 1]] })
		index = records.indexOf record
		@replaceState records: records
	updateRecord: (record, data) ->
		records = React.addons.update(@state.records, { $splice: [[index, 1, data]] })		
		index = records.indexOf record		
		@replaceState records: records
	render: -> 
		React.DOM.div
			className: 'records'
			React.DOM.h2
				className: 'title'
				'Records'
			React.createElement AmountBox, type: 'success', amount: @credits(), text: 'Credit'
			React.createElement AmountBox, type: 'danger', amount: @debits(), text: 'Debit'
			React.createElement AmountBox, type: 'info', amount: @balance(), text: 'Balance'			
			React.createElement RecordForm, handleNewRecord: @addRecord
			React.DOM.hr, null
			React.DOM.table
				className: 'table table-bordered'
				React.DOM.thead null,
					React.DOM.tr null,
						React.DOM.td null, "Date"
						React.DOM.td null, "Title"
						React.DOM.td null, "Amount"
						React.DOM.td null, "Actions"
				React.DOM.tbody null,
					for record in @state.records
						React.createElement Record, key: record.id, record: record, handleDeleteRecord: @deleteRecord, handleEditRecord: @updateRecord