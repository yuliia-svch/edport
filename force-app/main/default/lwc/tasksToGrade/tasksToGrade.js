import { LightningElement } from 'lwc';
import { Util } from 'c/util';
import communityPath from '@salesforce/community/basePath';
import NOEVENTS from '@salesforce/resourceUrl/noEvents';

import getTasksToGrade from '@salesforce/apex/CourseController.getTasksToGrade';

export default class TasksToGrade extends LightningElement {
    tasks = [];
    imageUrl = NOEVENTS;

    connectedCallback() {
        getTasksToGrade()
        .then(response => {
            this.tasks = response.map(item => {
                return {
                    ...item,
                    recordLink: communityPath + '/task/' + item.id
                }
            });
		}).catch(error => {
			Util.showToast(this, Util.parseError(error), Util.TOAST_VARIANTS.ERROR);
		})
    }
}