import { LightningElement } from 'lwc';
import { Util } from 'c/util';
import communityPath from '@salesforce/community/basePath';
import NOEVENTS from '@salesforce/resourceUrl/noEvents';

import getAssignmentsDue from '@salesforce/apex/CourseController.getAssignmentsDue';

export default class AssignmentsDue extends LightningElement {
    assignments = [];
    imageUrl = NOEVENTS;

    connectedCallback() {
        getAssignmentsDue()
        .then(response => {
            this.assignments = response.map(item => {
                return {
                    ...item,
                    recordLink: communityPath + '/assignment/' + item.id
                }
            });
		}).catch(error => {
			Util.showToast(this, Util.parseError(error), Util.TOAST_VARIANTS.ERROR);
		})
    }
}