/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Contract } = require('fabric-contract-api');

class DiseaseCodeContract extends Contract {

    async diseaseCodeExists(ctx, diseaseCodeId) {
        const buffer = await ctx.stub.getState(diseaseCodeId);
        return (!!buffer && buffer.length > 0);
    }

    async createDiseaseCode(ctx, diseaseCodeId, value) {
        const exists = await this.diseaseCodeExists(ctx, diseaseCodeId);
        if (exists) {
            throw new Error(`The disease code ${diseaseCodeId} already exists`);
        }
        const asset = { value };
        const buffer = Buffer.from(JSON.stringify(asset));
        await ctx.stub.putState(diseaseCodeId, buffer);
    }

    async readDiseaseCode(ctx, diseaseCodeId) {
        const exists = await this.diseaseCodeExists(ctx, diseaseCodeId);
        if (!exists) {
            throw new Error(`The disease code ${diseaseCodeId} does not exist`);
        }
        const buffer = await ctx.stub.getState(diseaseCodeId);
        const asset = JSON.parse(buffer.toString());
        return asset;
    }

    async updateDiseaseCode(ctx, diseaseCodeId, newValue) {
        const exists = await this.diseaseCodeExists(ctx, diseaseCodeId);
        if (!exists) {
            throw new Error(`The disease code ${diseaseCodeId} does not exist`);
        }
        const asset = { value: newValue };
        const buffer = Buffer.from(JSON.stringify(asset));
        await ctx.stub.putState(diseaseCodeId, buffer);
    }

    async deleteDiseaseCode(ctx, diseaseCodeId) {
        const exists = await this.diseaseCodeExists(ctx, diseaseCodeId);
        if (!exists) {
            throw new Error(`The disease code ${diseaseCodeId} does not exist`);
        }
        await ctx.stub.deleteState(diseaseCodeId);
    }

}

module.exports = DiseaseCodeContract;
