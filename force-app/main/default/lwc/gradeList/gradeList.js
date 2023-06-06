import { LightningElement, track } from 'lwc';
import { Util } from 'c/util';

import getGradeList from '@salesforce/apex/CourseController.getGradeList';

export default class GradeList extends LightningElement {
    @track gradeList = [];
    creditsSum = 0;
    gradePointsSum = 0;
    GPA = 0;
    activeSections = [];

    connectedCallback() {
        getGradeList()
		.then(response => {
			this.gradeList = response;
            this.gradeList.forEach(item => {
                this.creditsSum += item.credits;
                this.gradePointsSum += item.gradePoint;
                this.activeSections.push(item.courseName);
            })
            this.GPA = this.gradePointsSum / this.creditsSum;
            this.GPA = this.GPA.toFixed(2);
		}).catch(error => {
			Util.showToast(this, Util.parseError(error), Util.TOAST_VARIANTS.ERROR);
		})
    }
}