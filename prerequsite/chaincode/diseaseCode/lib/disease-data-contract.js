/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Contract } = require('fabric-contract-api');

class DiseaseDataContract extends Contract {

    async diseaseExists(ctx, diseaseUID) {
        const buffer = await ctx.stub.getState(diseaseUID);
        return (!!buffer && buffer.length > 0);
    }

    async readAll(ctx, diseaseUID) {
        const exists = await this.diseaseExists(ctx, diseaseUID);
        if (!exists) {
            throw new Error(`The diseaseId ${diseaseUID} does not exist`);
        }
        const buffer = await ctx.stub.getState(diseaseUID);
        const asset = JSON.parse(buffer.toString());
        // let readAll = { Type: 'The details are', Disease: asset };
        // await ctx.stub.SetEvent("createFarmerEvent", Buffer.from(JSON.stringify(readAll)))
        return asset;
    }

    async createFarmer(ctx, diseaseUID, farmerId, diseaseName, location, date) {
        // const mspID = ctx.clientIdentity.getMSPID();
        // if (mspID === 'farmer-fins-com') {
        const exists = await this.diseaseExists(ctx, diseaseUID);
        if (exists) {
            throw new Error(`The diseaseID ${diseaseUID} already exists`);
        }
        const asset = { diseaseUID, farmerId, diseaseName, location, date };
        const buffer = Buffer.from(JSON.stringify(asset));
        await ctx.stub.putState(diseaseUID, buffer);
        let addFarmerEventData = { Type: 'Farmer created crop data', diseaseName: diseaseName };
        await ctx.stub.setEvent("createFarmerEvent", Buffer.from(JSON.stringify(addFarmerEventData)))
        // }
        // else {
        //     return `under following MSPID ${mspID} cannot do the functionality`;
        // }
    }


    async updateFarmer(ctx, diseaseUID, farmerId, newdiseaseName, newdate) {
        const mspID = ctx.clientIdentity.getMSPID();
        if (mspID === 'farmer-fins-com') {
            const exists = await this.diseaseExists(ctx, diseaseUID);
            if (!exists) {
                throw new Error(`The farmer add ${diseaseUID} does not exist`);
            }
            const asset = { diseaseUID, farmerId, diseaseName: newdiseaseName, date: newdate };
            const buffer = Buffer.from(JSON.stringify(asset));
            await ctx.stub.putState(diseaseUID, buffer);
        }
        else {
            return `under following MSPID ${mspID} cannot do the functionality`;
        } const asset = JSON.parse(buffer.toString());
    }

    async deleteFarmer(ctx, diseaseUID) {
        const mspID = ctx.clientIdentity.getMSPID();
        if (mspID === 'farmer-fins-com') {
            const exists = await this.diseaseExists(ctx, diseaseUID);
            if (!exists) {
                throw new Error(`The farmer add ${diseaseUID} does not exist`);
            }
            await ctx.stub.deleteState(diseaseUID);
        }
        else {
            return `under following MSPID ${mspID} cannot do the functionality`;
        }
    }


    async createResearcher(ctx, diseaseUID, researcherAddId, diseaseName, location, date, duration) {
        const mspID = ctx.clientIdentity.getMSPID();
        if (mspID === 'researchers-fins-com') {
            const exists = await this.diseaseExists(ctx, researcherAddId);
            if (exists) {
                throw new Error(`The diseaseID ${diseaseUID} already exists`);
            }
            const asset = { diseaseUID, researcherAddId, diseaseName, location, date, duration };
            const buffer = Buffer.from(JSON.stringify(asset));
            await ctx.stub.putState(diseaseUID, buffer);
        }
        else {
            return `under following MSPID ${mspID} cannot do the functionality`;
        }
    }

    async updateResearcher(ctx, diseaseUID, researcherAddId, newdiseaseName, newdate, newduration) {
        const mspID = ctx.clientIdentity.getMSPID();
        if (mspID === 'researchers-fins-com') {
            const exists = await this.diseaseExists(ctx, diseaseUID);
            if (!exists) {
                throw new Error(`The diseaseID ${diseaseUID} does not exist`);
            }
            const asset = { diseaseUID: diseaseUID, researcherAddId: researcherAddId, diseaseName: newdiseaseName, date: newdate, duration: newduration };
            const buffer = Buffer.from(JSON.stringify(asset));
            await ctx.stub.putState(diseaseUID, buffer);
        }
        else {
            return `under following MSPID ${mspID} cannot do the functionality`;
        }
    }

    async deleteResearcher(ctx, diseaseUID) {
        const mspID = ctx.clientIdentity.getMSPID();
        if (mspID === 'researchers-fins-com') {
            const exists = await this.diseaseExists(ctx, diseaseUID);
            if (!exists) {
                throw new Error(`The diseaseID ${diseaseUID} does not exist`);
            }
            await ctx.stub.deleteState(diseaseUID);
        }
        else {
            return `under following MSPID ${mspID} cannot do the functionality`;
        }
    }

    async solutionOfficer(ctx, diseaseUID, officerAddID, newdiseaseName, newdate, newduration, newsolution) {
        const mspID = ctx.clientIdentity.getMSPID();
        if (mspID === 'officer-fins-com') {
            const exists = await this.diseaseExists(ctx, diseaseUID);
            if (!exists) {
                throw new Error(`The diseaseID ${diseaseUID} does not exist`);
            }
            const asset = { officerAddID, diseaseName: newdiseaseName, date: newdate, duration: newduration, solution: newsolution };
            const buffer = Buffer.from(JSON.stringify(asset));
            await ctx.stub.putState(diseaseUID, buffer);
        }
        else {
            return `under following MSPID ${mspID} cannot do the functionality`;
        }
    }

}

module.exports = DiseaseDataContract;
