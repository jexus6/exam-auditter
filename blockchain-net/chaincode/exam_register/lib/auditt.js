/*
 * BIM Document Contract
 */

'use strict';

const { Contract } = require('fabric-contract-api');


class ExamContract extends Contract {
  constructor() {
    // Unique namespace when multiple contracts per chaincode file
    super('com.jf.exam');
  }

  /**
   * Create document
   *
   * @param {Context} ctx the transaction context
   * @param {String} name name of the student
   * @param {String} hash hash of the exam
   * @param {String} subject subject of the exam
   * @param {String} timeStamp creation date
   * @param {String} signature student's signature
   */
  async createExam(
    ctx,
    hash,
    name,
    subject,
    timeStamp,
    signature
  ) {
    console.info('============= CREATE Exam registry ===========');
    let doc = {};
    doc.docType = 'exam';
    doc.name = name;
    doc.subject = subject;
    doc.hash = hash;
    doc.signature = signature;
    doc.timeStamp = timeStamp;
    console.log('Registering  exam: ' + doc);

    let documentAsBytes = await ctx.stub.getState(hash);
    if (!documentAsBytes || documentAsBytes.length === 0) {
      console.log('Exam registered' + doc);
      await ctx.stub.putState(hash, Buffer.from(JSON.stringify(doc)));
      console.log('Aditt finished');
      return {
        "exam": doc,
        "txId": "" + ctx.stub.getTxID()
    } 
    } else {
      throw new Error(`Exam with hash: ${hash} already exist`);
    }

    console.info('============= END : Create Document ===========');
  }

  /**
   * Get document (by hash)
   *
   * @param {Object} ctx
   * @param {String} hash
   */
  async getExam(ctx, hash) {
    console.log('getDocument start');

    let documentAsBytes = await ctx.stub.getState(hash);
    if (!documentAsBytes || documentAsBytes.length === 0) {
      throw new Error(`Document with hash: ${hash} does not exist`);
    }

    console.log('result: ' + documentAsBytes.toString());
    return documentAsBytes.toString();
  }

}

module.exports = ExamContract;
