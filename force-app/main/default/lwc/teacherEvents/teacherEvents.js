import { LightningElement } from 'lwc';
import { Util } from 'c/util';
import communityPath from '@salesforce/community/basePath';
import NOEVENTS from '@salesforce/resourceUrl/noEvents';

import getTeacherEvents from '@salesforce/apex/CourseController.getTeacherEvents';

export default class TeacherEvents extends LightningElement {
    events = [];
    imageUrl = NOEVENTS;

    connectedCallback() {
        getTeacherEvents()
        .then(response => {
            this.events = response.map(item => {
                return {
                    ...item,
                    recordLink: communityPath + (item.type == 'Lecture'? '/lecture/' : '/assignment/') + item.id
                }
            });
		}).catch(error => {
			Util.showToast(this, Util.parseError(error), Util.TOAST_VARIANTS.ERROR);
		})
    }
}