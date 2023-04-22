import { LightningElement, track, wire, api } from 'lwc';
import { Util } from 'c/util';
import FullCalendarJS from '@salesforce/resourceUrl/fullcalendarv3';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import Id from '@salesforce/user/Id';
import ContactId from '@salesforce/schema/User.ContactId';
import ProfileName from '@salesforce/schema/User.Profile.Name';

import getScheduleData from '@salesforce/apex/ScheduleController.getScheduleData';

export default class Schedule extends LightningElement {
	@api audience;
	userContactId;
	userProfileName;
	jsInitialised = false;
	@track events = [];
	@track eventsToDisplay = [];
	openModal = false;
	currentEventId;
	currentEventName;
	mode;

	connectedCallback() {
		this.refresh();
	}

	@wire(getRecord, { recordId: Id, fields: [ContactId, ProfileName] })
    userDetails({ error, data }) {
        if (error) {
            this.error = error;
        } else if (data) {
            if (data.fields.ContactId.value != null) {
                this.userContactId = data.fields.ContactId.value;
            }
            if (data.fields.Profile.value != null) {
                this.userProfileName = data.fields.Profile.value.fields.Name.value;
            }
        }
    }

	handleCancel() {
		this.openModal = false;
	}

	refresh() {
		getScheduleData({audience: this.audience})
		.then(response => {
			this.events = response;
			this.events.forEach(event => {
				this.eventsToDisplay.push({ 
					Id : event.id, 
					title : event.name, 
					start : event.startTime,
					end : event.endTime,
					allDay : false
				});
			});
			this.eventsToDisplay = JSON.parse(JSON.stringify(this.eventsToDisplay));
			this.renderCalendar();
		}).catch(error => {
			Util.showToast(this, Util.parseError(error), Util.TOAST_VARIANTS.ERROR);
		})
	}

	renderCalendar() {
		if (this.jsInitialised) {
			return;
		}
		this.jsInitialised = true;

		Promise.all([
			loadScript(this, FullCalendarJS + '/fullcalendar-3.10.0/lib/jquery.min.js'),
			loadScript(this, FullCalendarJS + '/fullcalendar-3.10.0/lib/moment.min.js'),
			loadScript(this, FullCalendarJS + '/fullcalendar-3.10.0/fullcalendar.min.js'),
			loadStyle(this, FullCalendarJS + '/fullcalendar-3.10.0/fullcalendar.min.css')
		])
		.then(() => {
			this.initialiseCalendarJs();
		})
		.catch(error => {
			new ShowToastEvent({
				title: 'Error!',
				message: error,
				variant: 'error'
			})
		})
	}

	initialiseCalendarJs() {
		var that = this;
		const ele = this.template.querySelector('div.fullcalendarjs');
		$(ele).fullCalendar({
			header: {
				left: 'prev,next today',
				center: 'title',
				right: 'month,basicWeek,basicDay'
			},
			defaultDate: new Date(),
			navLinks: true, 
			editable: true,
			eventLimit: true,
			events: this.eventsToDisplay,
			dragScroll:true,
			droppable:true,
			weekNumbers:true,
			selectable:true,
			eventClick: function (info) {
				let task = that.events.find(x => x.id == info.Id);
				that.currentEventId = info.Id;
				that.currentEventName = task.type === 'Lecture'? 'Lecture__c' : 'Assignment__c';
				console.log(that.currentEventId);
				console.log(that.currentEventName);
				that.mode = (that.userContactId === task.teacherId || that.userProfileName === 'System Administrator')? 'edit' : 'view';
				that.openModal = true;
			}
		});
	}
}