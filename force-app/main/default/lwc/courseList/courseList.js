import { LightningElement } from 'lwc';
import { Util } from 'c/util';

import getStudentCourses from '@salesforce/apex/CourseController.getStudentCourses';

const columns = [
	{ label: 'Name', fieldName: 'link', type: 'url', typeAttributes: { label: {fieldName: 'name'}} },
	{ label: 'Credits', fieldName: 'credits' }
];

export default class CourseList extends LightningElement {
	courses = [];
	columns = columns;

	connectedCallback() {
		getStudentCourses()
		.then(response => {
			this.courses = response;
		}).catch(error => {
			Util.showToast(this, Util.parseError(error), Util.TOAST_VARIANTS.ERROR);
		})
	}
}