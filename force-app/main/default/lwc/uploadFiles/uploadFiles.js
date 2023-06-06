import { LightningElement, api, track, wire } from 'lwc';
import { Util } from 'c/util';

import createContentDistributions from '@salesforce/apex/FileController.createContentDistributions';
import getFiles from '@salesforce/apex/FileController.getFiles';
import deleteFile from '@salesforce/apex/FileController.deleteFile';

export default class UploadFiles extends LightningElement {
    @api showUpload;
    @api recordId;
    @track files = [];

    connectedCallback() {
        this.refresh();
    }

    refresh() {
        getFiles({recordId : this.recordId}).then(response => {
            this.files = response;
        }).catch(error => {
            Util.showToast(this, Util.parseError(error), Util.TOAST_VARIANTS.ERROR);
        });
    }
    
    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        let docIds = [];
        uploadedFiles?.forEach(file => {
            docIds.push(file.documentId);
        });
        createContentDistributions({docIds : docIds, recordId : this.recordId})
        .then(() => {
            this.refresh();
        }).catch(error => {
            Util.showToast(this, Util.parseError(error), Util.TOAST_VARIANTS.ERROR);
        })
    }

    deleteFile(event) {
        const id = event.target.dataset.id;
        deleteFile({fileId : id})
        .then(() => {
            this.refresh();
        }).catch(error => {
            Util.showToast(this, Util.parseError(error), Util.TOAST_VARIANTS.ERROR);
        })
    }
}